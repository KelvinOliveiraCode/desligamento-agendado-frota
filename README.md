# desligamento-agendado-frota

![linguagem: PowerShell](https://img.shields.io/badge/linguagem-PowerShell-blue?logo=powershell)   ![status: concluido](https://img.shields.io/badge/status-concluido-green)   ![licenca: MIT](https://img.shields.io/badge/licenca-MIT-blue)

## Resumo

Scripts PowerShell para preparo e administracao de estacoes Windows. Projeto funcional, desligamento-agendado-frota

## Problema / por que existe

Preparar uma estacao Windows envolve varias etapas manuais (configuracao, instalacao, verificacao). Os scripts automatizam essa preparacao com modo dry-run por padrao e log de acoes.

## Arquitetura

- Cada script e um modulo independente com funcoes especificas.
- Dry-run por padrao: mostra o que faria sem executar mudancas reais.
- Log de acoes para auditoria e revisao.

## Tecnologias

- PowerShell 5.1 / 7

## O que faz

Projeto funcional, desligamento-agendado-frota

## Como rodar

Requisitos: Windows com PowerShell.

```
# executar com dry-run (seguro)
.\script.ps1

# executar de verdade
.\script.ps1 -Execute
```

## Estrutura do projeto

- tests/ (1 arquivo(s))
- .gitignore, BRIEF.md, desligamento.ps1, README.en.md, README.md


## Trade-offs e decisões

- Dry-run por padrao evita mudancas acidentais.
- Log de acoes para rastreabilidade.
- Scripts independentes, faceis de adaptar.

## Limitações conhecidas

- Funciona apenas em Windows.
- Requer permissoes de administrador para algumas acoes.

## Testes

Nenhum teste automatizado detectado.

## Licença

Distribuído sob a licenca MIT. Consulte o arquivo `LICENSE` do repositorio.

## Autor

Kelvin Oliveira, https://github.com/KelvinOliveiraCode
Portfolio: https://kelvinoliveiracode.github.io/portfolio/
