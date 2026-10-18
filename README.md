# desligamento-agendado-frota

[![PowerShell](https://img.shields.io/badge/PowerShell-5.1-blue?logo=powershell)](https://learn.microsoft.com/powershell/)   ![status: concluido](https://img.shields.io/badge/status-concluido-green)   ![licenca: MIT](https://img.shields.io/badge/licenca-MIT-blue)

## Resumo

Projeto funcional ,  desligamento-agendado-frota
## Problema / Por que existe

O projeto aborda um recorte prático e automatiza uma tarefa que, feita manualmente, é repetitiva e propensa a erro. O foco está em transformar dados ou processos em saída confiável, com código legível, testável e extensível.
## Arquitetura

Arquivos de código (5):
- `BRIEF.md`
- `desligamento.ps1`
- `README.en.md`
- `README.md`
- `Desligamento.Tests.ps1`
## Padrões de Projeto e Técnicas Identificadas

- PowerShell automation
## O que faz

Projeto funcional ,  desligamento-agendado-frota
## Como rodar

Requisitos: Windows com PowerShell 5.1+.

```powershell
# executar com dry-run (seguro)
.\script.ps1

# executar de verdade
.\script.ps1 -Execute
```
## Estrutura do Projeto

- `BRIEF.md`
- `desligamento.ps1`
- `README.en.md`
- `README.md`
- `Desligamento.Tests.ps1`
## Trade-offs e Decisões Técnicas

- Dry-run por padrão evita mudanças acidentais; execução real exige flag explícita (`-Execute`).
- Log de ações para auditoria e revisão posterior.
- Scripts independentes, fáceis de adaptar e compor.
## Limitações Conhecidas

- Funciona apenas em Windows.
- Requer permissões de administrador para algumas ações (instalação, configuração de serviço).
- Sem rollback automático; dry-run mostra o que faria, mas não desfaz se executado.
## Testes

Nenhum teste automatizado detectado (projeto de documentação/guia).
## Licença

Distribuído sob a licença MIT. Consulte o arquivo `LICENSE` do repositório.
## Autor

Kelvin Oliveira ,  https://github.com/KelvinOliveiraCode
Portfolio: https://kelvinoliveiracode.github.io/portfolio/
