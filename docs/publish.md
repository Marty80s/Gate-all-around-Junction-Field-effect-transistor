# Repository maintenance

Canonical repository: https://github.com/Marty80s/Gate-all-around-Junction-Field-effect-transistor

The main branch contains the organized TCAD prototype and documentation. The existing SDE branch retains its previous history.

Run `python3 tools/export_curves.py` from the repository root to regenerate the CSV exports. Use a licensed Sentaurus installation for simulation. Keep generated run outputs and proprietary material tables outside version control, as configured in `.gitignore`.
