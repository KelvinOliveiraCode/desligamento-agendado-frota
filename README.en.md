# desligamento-agendado-frota

[![PowerShell](https://img.shields.io/badge/PowerShell-5.1-blue?logo=powershell)](https://learn.microsoft.com/powershell/)   ![status: done](https://img.shields.io/badge/status-done-green)   ![license: MIT](https://img.shields.io/badge/license-MIT-blue)

## Summary

Projeto funcional ,  desligamento-agendado-frota
## Problem / Why it exists

The project addresses a practical scope and automates a task that, done manually, is repetitive and error-prone. The focus is on turning data or processes into reliable output, with readable, testable, and extensible code.
## Architecture

Code files (5):
- `BRIEF.md`
- `desligamento.ps1`
- `README.en.md`
- `README.md`
- `Desligamento.Tests.ps1`
## Design Patterns and Techniques Identified

- PowerShell automation
## What it does

Projeto funcional ,  desligamento-agendado-frota
## How to run

Requirements: Windows with PowerShell 5.1+.

```powershell
# run with dry-run (safe)
.\script.ps1

# run for real
.\script.ps1 -Execute
```
## Project Structure

- `BRIEF.md`
- `desligamento.ps1`
- `README.en.md`
- `README.md`
- `Desligamento.Tests.ps1`
## Trade-offs and Technical Decisions

- Dry-run by default avoids accidental changes; real execution requires explicit flag (`-Execute`).
- Action logging for auditing and later review.
- Independent scripts, easy to adapt and compose.
## Known Limitations

- Windows only.
- Requires administrator permissions for some actions (installation, service configuration).
- No automatic rollback; dry-run shows what would happen but does not undo if executed.
## Tests

No automated tests detected (documentation/guide project).
## License

Distributed under the MIT License. See the `LICENSE` file in this repository.
## Author

Kelvin Oliveira ,  https://github.com/KelvinOliveiraCode
Portfolio: https://kelvinoliveiracode.github.io/portfolio/
