# desligamento-agendado-frota

<div align="center">

[English](README.en.md) · **Português (Brasil)**

</div>

[![PowerShell](https://img.shields.io/badge/PowerShell-5.1%2B-5391FE?style=flat-square&logo=powershell)](https://learn.microsoft.com/powershell/) [![Windows](https://img.shields.io/badge/Windows-10%2F11-0078D6?style=flat-square&logo=windows)](https://www.microsoft.com/windows) [![MIT License](https://img.shields.io/badge/License-MIT-f4c430?style=flat-square)](LICENSE)

### Projeto funcional ,  desligamento-agendado-frota

---

## O que é

Projeto funcional ,  desligamento-agendado-frota

---

## Início Rápido

```powershell
# Clone e entre
git clone https://github.com/KelvinOliveiraCode/<repo>.git
cd <repo>

# Dry-run (visualização segura)
.\script.ps1

# Execute de verdade
.\script.ps1 -Execute
```

## Como funciona

**Arquitetura de scripts modulares** ,  cada script é um módulo independente:
- **Dry-run por padrão** ,  visualização segura antes da execução
- **Flag explícita `-Execute`** para mudanças reais
- **Log de ações** para rastreabilidade
- **Sem dependências externas** ,  PowerShell puro

---

## Capacidades

| Capacidade | Descrição |
|------------|-------------|
| Setup de Workstation | Configuração automatizada de Windows (apps, configurações, features) |
| Segurança Dry-run | Preview de todas as mudanças antes da execução com flag `-Execute` |
| Log de Auditoria | Toda ação registrada para revisão e conformidade |
| Design Modular | Scripts independentes ,  compor ou executar individualmente |
| Sem Dependências | PowerShell 5.1+ puro ,  sem módulos externos |


---



---

## Perguntas Frequentes

<details>
<summary><strong>O que é este projeto?</strong></summary>

Um estudo/projeto em PowerShell demonstrando PowerShell automation.

</details>

<details>
<summary><strong>Como executar?</strong></summary>

Veja [Início Rápido](#início-rápido) para comandos copiáveis.

</details>

<details>
<summary><strong>Há testes?</strong></summary>

Nenhum teste automatizado neste repositório.

</details>

<details>
<summary><strong>Posso usar em produção?</strong></summary>

Este é um **projeto de estudo/portfólio**. Revise e endureça (auth, persistência, monitoramento, etc.) antes de usar em produção.

</details>



---

## Documentação

- **Código-Fonte** ,  Navegue pelo diretório `src/` para detalhes de implementação
- **Referência da API** ,  N/A
- **Diagrama de Arquitetura** ,  Veja [architecture.mermaid](docs/architecture.mermaid) (se presente)
- **Changelog** ,  [CHANGELOG.md](CHANGELOG.md) (se presente)
- **Contribuindo** ,  [CONTRIBUTING.md](CONTRIBUTING.md) (se presente)

## Licença

[MIT](LICENSE) ,  Kelvin Oliveira

---

<div align="center">

**Construído com** · PowerShell 5.1+

**Autor** · [Kelvin Oliveira](https://github.com/KelvinOliveiraCode) · [Portfolio](https://kelvinoliveiracode.github.io/portfolio/)

</div>