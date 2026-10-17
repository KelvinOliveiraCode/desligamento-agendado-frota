<#
.SYNOPSIS
    Agendamento de desligamento/reinício de estações de trabalho (Suporte TI).
.DESCRIPTION
    Wrapper em PowerShell 5.1 em torno do shutdown.exe (/s, /r, /t, /a) que
    registra cada agendamento em um log de execução e permite listar e cancelar
    os agendamentos pendentes. Não agenda nada ao ser carregado: define apenas
    as funções New-Agendamento, Reiniciar-Agendado (alias), Listar-Agendamentos,
    Cancelar-Agendamento, Parse-Agenda, Escrever-Log e Obter-Log.
.AUTOR
    Kelvin Oliveira
.LICENÇA
    MIT
#>

#requires -Version 5.1

Set-StrictMode -Version Latest

$script:Agendamentos     = @()
$script:LogEntradas      = @()
$script:LogPath          = Join-Path $env:TEMP 'desligamento-agendado-frota.log'
$script:InvocadorShutdown = {
    param($Argumentos)
    & shutdown.exe @Argumentos
}

function Parse-Agenda {
    <#
    .SYNOPSIS
        Converte uma expressão de tempo em segundos e instante de execução.
    .PARAMETER Quando
        Expressão de tempo: segundos ("120"), minutos ("30m"), horas ("1h30m")
        ou hora absoluta no dia ("14:30").
    .PARAMETER Referencia
        Instante de referência usado para horas absolutas (padrão: agora).
    .OUTPUTS
        PSCustomObject com Segundos [int], Absoluto [bool] e ExecutarEm [DateTime].
    #>
    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $true)]
        [string] $Quando,

        [datetime] $Referencia = (Get-Date)
    )

    $limpo = $Quando.Trim()

    # Hora absoluta HH:mm
    if ($limpo -match '^(\d{1,2}):(\d{2})$') {
        $hora = [int]$Matches[1]
        $min  = [int]$Matches[2]
        if ($hora -lt 0 -or $hora -gt 23 -or $min -lt 0 -or $min -gt 59) {
            throw "Hora inválida: '$Quando' (use HH:mm, de 00:00 a 23:59)."
        }
        $alvo = $Referencia.Date.AddHours($hora).AddMinutes($min)
        if ($alvo -le $Referencia) {
            $alvo = $alvo.AddDays(1)
        }
        return [PSCustomObject]@{
            Segundos  = [int]($alvo - $Referencia).TotalSeconds
            Absoluto  = $true
            ExecutarEm = $alvo
        }
    }

    # Segundos puros
    if ($limpo -match '^(\d+)$') {
        $segundos = [int]$Matches[1]
        return [PSCustomObject]@{
            Segundos  = $segundos
            Absoluto  = $false
            ExecutarEm = $Referencia.AddSeconds($segundos)
        }
    }

    # Duração relativa combinando h e m
    $total = 0
    $usado = $false
    if ($limpo -match '^(\d+)h') {
        $total += [int]$Matches[1] * 3600
        $usado = $true
    }
    if ($limpo -match '(\d+)m') {
        $total += [int]$Matches[1] * 60
        $usado = $true
    }
    if (-not $usado -or $total -le 0) {
        throw "Formato de agendamento inválido: '$Quando'. Use '120', '30m', '1h30m' ou '14:30'."
    }
    return [PSCustomObject]@{
        Segundos  = $total
        Absoluto  = $false
        ExecutarEm = $Referencia.AddSeconds($total)
    }
}

function Escrever-Log {
    <#
    .SYNOPSIS
        Grava uma linha no log de execução (arquivo e memória).
    .PARAMETER Evento
        Nome do evento (Agendado, Cancelado, Erro).
    .PARAMETER Detalhe
        Texto livre com dados do evento.
    #>
    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $true)]
        [string] $Evento,

        [Parameter(Mandatory = $true)]
        [string] $Detalhe
    )

    $entrada = [PSCustomObject]@{
        Timestamp = (Get-Date).ToString('o')
        Evento    = $Evento
        Detalhe   = $Detalhe
    }
    $script:LogEntradas += $entrada
    $linha = ($entrada | ConvertTo-Csv -NoTypeInformation).Trim()
    $utf8 = New-Object System.Text.UTF8Encoding($false)
    [System.IO.File]::AppendAllText($script:LogPath, "$linha`n", $utf8)
}

function Obter-Log {
    <#
    .SYNOPSIS
        Retorna as entradas do log de execução em memória.
    .PARAMETER Evento
        Filtra por nome do evento (opcional).
    #>
    [CmdletBinding()]
    param(
        [string] $Evento
    )

    if ($Evento) {
        return $script:LogEntradas | Where-Object { $_.Evento -eq $Evento }
    }
    return $script:LogEntradas
}

function New-Agendamento {
    <#
    .SYNOPSIS
        Agenda desligamento ou reinício da estação de trabalho.
    .PARAMETER Acao
        Desligamento ou Reinício.
    .PARAMETER Quando
        Tempo até a execução (veja Parse-Agenda).
    .PARAMETER Computador
        Computador alvo (padrão: localhost).
    .PARAMETER Comentario
        Mensagem exibida aos usuários (passada ao shutdown.exe via /c).
    .OUTPUTS
        PSCustomObject representando o agendamento criado.
    #>
    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $true)]
        [ValidateSet('Desligamento', 'Reinício')]
        [string] $Acao,

        [Parameter(Mandatory = $true)]
        [string] $Quando,

        [string] $Computador = $env:COMPUTERNAME,

        [string] $Comentario = 'Desligamento agendado pela equipe de Suporte TI.'
    )

    $parsed   = Parse-Agenda -Quando $Quando -Referencia (Get-Date)
    $segundos = $parsed.Segundos

    # Cada token vai como elemento separado do array: /t e o valor, /c e o texto,
    # nunca uma string única com espaços (o shutdown.exe analisa o argv).
    $argumentos = @()
    if ($Acao -eq 'Reinício') {
        $argumentos += '/r'
    } else {
        $argumentos += '/s'
    }
    $argumentos += '/t'
    $argumentos += $segundos.ToString()
    if ($Computador -ne $env:COMPUTERNAME) {
        $argumentos += '/m'
        $argumentos += "\\$Computador"
    }
    if ($Comentario) {
        $argumentos += '/c'
        $argumentos += $Comentario
    }

    # $script:InvocadorShutdown é um seam: testes substituem por um scriptblock que
    # apenas grava os argumentos; em produção chama o shutdown.exe de verdade.
    & $script:InvocadorShutdown $argumentos

    $id = "AGD-{0:yyyyMMddHHmmssfff}" -f (Get-Date)
    $job = [PSCustomObject]@{
        Id          = $id
        Acao        = $Acao
        Quando      = $Quando
        Segundos    = $segundos
        ExecutarEm  = $parsed.ExecutarEm
        Computador  = $Computador
        Comentario  = $Comentario
        Status      = 'Agendado'
        Comando     = "shutdown.exe $($argumentos -join ' ')"
    }
    $script:Agendamentos += $job
    Escrever-Log -Evento 'Agendado' -Detalhe "$id | $Acao | $Computador | em $($parsed.ExecutarEm) | $($job.Comando)"
    return $job
}

function Reiniciar-Agendado {
    <#
    .SYNOPSIS
        Alias de New-Agendamento com Acao = Reinício.
    .PARAMETER Quando
        Tempo até o reinício (veja Parse-Agenda).
    .PARAMETER Computador
        Computador alvo (padrão: localhost).
    .PARAMETER Comentario
        Mensagem exibida aos usuários.
    #>
    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $true)]
        [string] $Quando,

        [string] $Computador = $env:COMPUTERNAME,

        [string] $Comentario = 'Reinício agendado pela equipe de Suporte TI.'
    )

    return New-Agendamento -Acao Reinício -Quando $Quando -Computador $Computador -Comentario $Comentario
}

function Listar-Agendamentos {
    <#
    .SYNOPSIS
        Lista agendamentos registrados.
    .PARAMETER Status
        Filtra por status (padrão: Agendado).
    .OUTPUTS
        PSCustomObject[] com os agendamentos que correspondem ao filtro.
    #>
    [CmdletBinding()]
    param(
        [string] $Status = 'Agendado'
    )

    return $script:Agendamentos | Where-Object { $_.Status -eq $Status }
}

function Cancelar-Agendamento {
    <#
    .SYNOPSIS
        Cancela um agendamento pendente (aborta o temporizador do shutdown.exe).
    .PARAMETER Id
        Identificador do agendamento retornado por New-Agendamento.
    .OUTPUTS
        PSCustomObject do agendamento cancelado.
    #>
    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $true)]
        [string] $Id
    )

    $agendamento = $script:Agendamentos | Where-Object { $_.Id -eq $Id }
    if (-not $agendamento) {
        throw "Agendamento não encontrado: $Id"
    }

    & $script:InvocadorShutdown '/a'
    $agendamento.Status = 'Cancelado'
    Escrever-Log -Evento 'Cancelado' -Detalhe "$Id | cancelado"
    return $agendamento
}
