<#
.SYNOPSIS
    Testes do módulo desligamento-agendado-frota (Suporte TI).
.DESCRIPTION
    Suíte Pester 3.4.0. O módulo é dot-sourced dentro de cada bloco It para que
    o seam $script:InvocadorShutdown (substituído por um scriptblock que apenas
    grava os argumentos) fique no mesmo escopo do módulo. Não agenda
    desligamentos de verdade.
#>

Describe 'Parse-Agenda' {
    BeforeAll {
        . (Join-Path $PSScriptRoot '..\desligamento.ps1')
    }

    It 'converte segundos puros em agendamento relativo' {
        $referencia = [datetime]'2026-01-01T12:00:00'
        $resultado = Parse-Agenda -Quando '120' -Referencia $referencia
        $resultado.Segundos | Should Be 120
        $resultado.Absoluto | Should Be $false
        $resultado.ExecutarEm | Should Be $referencia.AddSeconds(120)
    }

    It 'converte minutos com sufixo m' {
        $resultado = Parse-Agenda -Quando '30m' -Referencia ([datetime]'2026-01-01T12:00:00')
        $resultado.Segundos | Should Be 1800
        $resultado.Absoluto | Should Be $false
    }

    It 'converte horas com sufixo h' {
        $resultado = Parse-Agenda -Quando '1h' -Referencia ([datetime]'2026-01-01T12:00:00')
        $resultado.Segundos | Should Be 3600
    }

    It 'combina horas e minutos' {
        $resultado = Parse-Agenda -Quando '1h30m' -Referencia ([datetime]'2026-01-01T12:00:00')
        $resultado.Segundos | Should Be 5400
    }

    It 'hora absoluta agendada para hoje quando ainda não passou' {
        $referencia = [datetime]'2026-01-01T12:00:00'
        $resultado = Parse-Agenda -Quando '14:30' -Referencia $referencia
        $resultado.Absoluto | Should Be $true
        $resultado.ExecutarEm | Should Be ([datetime]'2026-01-01T14:30:00')
    }

    It 'hora absoluta passa para o dia seguinte se já passou' {
        $referencia = [datetime]'2026-01-01T23:00:00'
        $resultado = Parse-Agenda -Quando '14:30' -Referencia $referencia
        $resultado.ExecutarEm | Should Be ([datetime]'2026-01-02T14:30:00')
    }

    It 'rejeita texto inválido' {
        { Parse-Agenda -Quando 'abc' } | Should Throw
    }

    It 'rejeita hora fora de faixa' {
        { Parse-Agenda -Quando '25:00' } | Should Throw
        { Parse-Agenda -Quando '12:60' } | Should Throw
    }
}

Describe 'Agendamento (shutdown.exe simulado)' {
    It 'agenda desligamento e registra no log de execução' {
        . (Join-Path $PSScriptRoot '..\desligamento.ps1')
        $script:LogPath      = Join-Path $env:TEMP ("desligamento-agendado-frota-test-{0}.log" -f [guid]::NewGuid())
        $script:Agendamentos = @()
        $script:LogEntradas  = @()
        $script:InvocadorShutdown = {
            param($Argumentos)
            $null = $script:ChamadasShutdown += $Argumentos
        }
        $script:ChamadasShutdown = @()

        $job = New-Agendamento -Acao Desligamento -Quando '30m' -Computador $env:COMPUTERNAME -Comentario 'teste'
        $job.Status | Should Be 'Agendado'
        $job.Acao | Should Be 'Desligamento'
        $job.Segundos | Should Be 1800
        $job.Computador | Should Be $env:COMPUTERNAME
        $job.Comando | Should Be "shutdown.exe /s /t 1800 /c teste"
        ($script:ChamadasShutdown -contains '/s') | Should Be $true
        ($script:ChamadasShutdown -contains '/t') | Should Be $true
        ($script:ChamadasShutdown -contains '1800') | Should Be $true
        ($script:LogEntradas | Where-Object { $_.Evento -eq 'Agendado' }) | Should Not Be $null
        if (Test-Path $script:LogPath) { Remove-Item -Path $script:LogPath -Force }
    }

    It 'agenda reinício com /r e computador remoto' {
        . (Join-Path $PSScriptRoot '..\desligamento.ps1')
        $script:LogPath      = Join-Path $env:TEMP ("desligamento-agendado-frota-test-{0}.log" -f [guid]::NewGuid())
        $script:Agendamentos = @()
        $script:LogEntradas  = @()
        $script:ChamadasShutdown = @()
        $script:InvocadorShutdown = {
            param($Argumentos)
            $null = $script:ChamadasShutdown += $Argumentos
        }

        New-Agendamento -Acao Reinício -Quando '1h' -Computador SERVIDOR01 | Out-Null
        ($script:ChamadasShutdown -contains '/r') | Should Be $true
        ($script:ChamadasShutdown -contains '/t') | Should Be $true
        ($script:ChamadasShutdown -contains '3600') | Should Be $true
        ($script:ChamadasShutdown -contains '/m') | Should Be $true
        ($script:ChamadasShutdown -contains '\\SERVIDOR01') | Should Be $true
        if (Test-Path $script:LogPath) { Remove-Item -Path $script:LogPath -Force }
    }

    It 'lista apenas agendamentos pendentes' {
        . (Join-Path $PSScriptRoot '..\desligamento.ps1')
        $script:LogPath      = Join-Path $env:TEMP ("desligamento-agendado-frota-test-{0}.log" -f [guid]::NewGuid())
        $script:Agendamentos = @()
        $script:LogEntradas  = @()
        $script:ChamadasShutdown = @()
        $script:InvocadorShutdown = {
            param($Argumentos)
            $null = $script:ChamadasShutdown += $Argumentos
        }

        $job1 = New-Agendamento -Acao Desligamento -Quando '10m'
        $job2 = New-Agendamento -Acao Reinício -Quando '20m'
        $pendentes = Listar-Agendamentos -Status 'Agendado'
        ($pendentes | Measure-Object).Count | Should Be 2
        ($pendentes.Id -contains $job1.Id) | Should Be $true
        ($pendentes.Id -contains $job2.Id) | Should Be $true
        if (Test-Path $script:LogPath) { Remove-Item -Path $script:LogPath -Force }
    }

    It 'cancela agendamento, envia shutdown /a e remove da lista de pendentes' {
        . (Join-Path $PSScriptRoot '..\desligamento.ps1')
        $script:LogPath      = Join-Path $env:TEMP ("desligamento-agendado-frota-test-{0}.log" -f [guid]::NewGuid())
        $script:Agendamentos = @()
        $script:LogEntradas  = @()
        $script:ChamadasShutdown = @()
        $script:InvocadorShutdown = {
            param($Argumentos)
            $null = $script:ChamadasShutdown += $Argumentos
        }

        $job = New-Agendamento -Acao Desligamento -Quando '5m'
        $cancelado = Cancelar-Agendamento -Id $job.Id
        $cancelado.Status | Should Be 'Cancelado'
        ($script:ChamadasShutdown -contains '/a') | Should Be $true
        (Listar-Agendamentos -Status 'Agendado' | Measure-Object).Count | Should Be 0
        if (Test-Path $script:LogPath) { Remove-Item -Path $script:LogPath -Force }
    }

    It 'cancelar id inexistente lança erro' {
        . (Join-Path $PSScriptRoot '..\desligamento.ps1')
        $script:Agendamentos = @()
        $script:LogEntradas  = @()
        $script:InvocadorShutdown = {
            param($Argumentos)
        }

        { Cancelar-Agendamento -Id 'NAO-EXISTE' } | Should Throw
    }
}
