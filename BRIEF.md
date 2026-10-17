# BRIEF — desligamento-agendado-frota

Projeto da área Suporte TI: desligamento/reinício agendado de estações de trabalho (MVP).

## Entregas

| Arquivo | Conteúdo |
|---------|----------|
| `desligamento.ps1` | Módulo PowerShell 5.1: `New-Agendamento`, `Reiniciar-Agendado`, `Listar-Agendamentos`, `Cancelar-Agendamento`, `Parse-Agenda`, `Escrever-Log`, `Obter-Log`. Agenda `shutdown /s` ou `/r` com tempo, registra execução em log, lista e cancela agendamentos pendentes. |
| `tests\Desligamento.Tests.ps1` | Suíte Pester 3.4.0 com 13 testes: parsing de agendamento (mínimo obrigatório), agendamento/desligamento, reinício remoto, listagem de pendentes, cancelamento com `shutdown /a` e erro de id inexistente. |
| `README.md` | Documentação bilíngue PT-BR + EN: título, descrição, como usar, testes, licença MIT, autor Kelvin Oliveira. |
| `BRIEF.md` | Este documento. |

## Como verificar

Comando de teste:

```powershell
Invoke-Pester -Script C:\Users\Kelvin\AppData\Local\Temp\opencode\github-staging\projects\desligamento-agendado-frota\tests\Desligamento.Tests.ps1
```

Resultado esperado: 13 aprovados, 0 falhados, 0 pendentes.

Ambiente verificado: Windows PowerShell 5.1 + Pester 3.4.0 (`pwsh` não instalado). Os testes simulam o envio de comandos ao `shutdown.exe`; nenhum desligamento real é executado e nenhum fica pendente após a suíte.

## Caminhos

- README: `C:\Users\Kelvin\AppData\Local\Temp\opencode\github-staging\projects\desligamento-agendado-frota\README.md`
- BRIEF: `C:\Users\Kelvin\AppData\Local\Temp\opencode\github-staging\projects\desligamento-agendado-frota\BRIEF.md`

## Licença

MIT. Autor: Kelvin Oliveira.
