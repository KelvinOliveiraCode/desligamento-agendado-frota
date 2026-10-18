
# desligamento-agendado-frota

![language: PowerShell](https://img.shields.io/badge/language-PowerShell-blue?logo=powershell)   ![status: done](https://img.shields.io/badge/status-done-green)   ![license: MIT](https://img.shields.io/badge/license-MIT-blue)

## Summary

PowerShell scripts for preparing and administering Windows workstations. Projeto funcional, desligamento-agendado-frota

## Problem / why it exists

Preparing a Windows workstation involves several manual steps (configuration, installation, verification). The scripts automate this preparation with dry-run mode by default and action logging.

## Architecture

- Each script is an independent module with specific functions.
- Dry-run by default: shows what it would do without executing real changes.
- Action logging for auditing and review.

## Technologies

- PowerShell 5.1 / 7

## What it does

Projeto funcional, desligamento-agendado-frota

## How to run

Requirements: Windows with PowerShell.

```
# run with dry-run (safe)
.\script.ps1

# run for real
.\script.ps1 -Execute
```

## Project structure

- tests/ (1 arquivo(s))
- .gitignore, BRIEF.md, desligamento.ps1, README.en.md, README.md


## Trade-offs and decisions

- Dry-run by default avoids accidental changes.
- Action logging for traceability.
- Independent scripts, easy to adapt.

## Known limitations

- Windows only.
- Requires administrator permissions for some actions.

## Tests

No automated tests detected.

## License

Distributed under the MIT License. See the `LICENSE` file in this repository.

## Author

Kelvin Oliveira, https://github.com/KelvinOliveiraCode
Portfolio: https://kelvinoliveiracode.github.io/portfolio/
