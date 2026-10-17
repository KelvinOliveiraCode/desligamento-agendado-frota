# desligamento-agendado-frota

Agendamento de desligamento e reinício de estações de trabalho — Suporte TI.

## Descrição

Módulo PowerShell 5.1 que agenda desligamento (`shutdown /s`) ou reinício (`shutdown /r`) de estações com tempo de espera, registra cada execução em log e permite listar e cancelar agendamentos pendentes. Escopo mínimo (MVP): agendar, listar, cancelar e logar. Não há dependências externas além do Windows PowerShell 5.1 e do `shutdown.exe` do sistema.

## Como usar

Pré-requisitos: Windows PowerShell 5.1 e o `shutdown.exe` do Windows.

Carregue o módulo:

```powershell
. C:\caminho\para\desligamento.ps1
```

Agende um desligamento em 30 minutos:

```powershell
$job = New-Agendamento -Acao Desligamento -Quando '30m' -Computador $env:COMPUTERNAME -Comentario 'Manutenção de frota'
```

Agende um reinício em um horário absoluto:

```powershell
New-Agendamento -Acao Reinício -Quando '14:30' -Computador SERVIDOR01
```

Formatos aceitos em `-Quando`: `120` (segundos), `30m` (minutos), `1h30m` (horas e minutos) ou `14:30` (hora absoluta; se já passou, agenda para o dia seguinte).

Liste os agendamentos pendentes:

```powershell
Listar-Agendamentos
```

Cancela um agendamento (envia `shutdown /a`):

```powershell
Cancelar-Agendamento -Id <id-do-agendamento>
```

## Testes

A suíte usa Pester 3.4.0 e não executa `shutdown.exe` de verdade (o envio de comandos é simulado).

```powershell
Invoke-Pester -Script C:\caminho\para\tests\Desligamento.Tests.ps1
```

Resultado esperado: 13 de 13 aprovados, incluindo o teste obrigatório de parsing de agendamento (`Parse-Agenda`).

## Licença

MIT. Autor: Kelvin Oliveira.

---

# desligamento-agendado-frota

Scheduled shutdown and restart of workstations — IT Support.

## Description

PowerShell 5.1 module that schedules shutdown (`shutdown /s`) or restart (`shutdown /r`) of workstations with a wait time, logs every execution, and allows listing and cancelling pending schedules. MVP scope: schedule, list, cancel, log. No external dependencies besides Windows PowerShell 5.1 and the system `shutdown.exe`.

## Usage

Prerequisites: Windows PowerShell 5.1 and the system `shutdown.exe`.

Dot-source the module:

```powershell
. C:\path\to\desligamento.ps1
```

Schedule a shutdown in 30 minutes:

```powershell
$job = New-Agendamento -Acao Desligamento -Quando '30m' -Computador $env:COMPUTERNAME -Comentario 'Fleet maintenance'
```

Schedule a restart at an absolute time:

```powershell
New-Agendamento -Acao Reinício -Quando '14:30' -Computador SERVIDOR01
```

Accepted `-Quando` formats: `120` (seconds), `30m` (minutes), `1h30m` (hours and minutes), or `14:30` (absolute time; if already passed, schedules for the next day).

List pending schedules:

```powershell
Listar-Agendamentos
```

Cancel a schedule (sends `shutdown /a`):

```powershell
Cancelar-Agendamento -Id <job-id>
```

## Tests

The suite uses Pester 3.4.0 and does not run `shutdown.exe` for real (command sending is mocked).

```powershell
Invoke-Pester -Script C:\path\to\tests\Desligamento.Tests.ps1
```

Expected result: 13 of 13 passed, including the mandatory schedule parsing test (`Parse-Agenda`).

## License

MIT. Author: Kelvin Oliveira.
