# Evidence and validation notes

## Historical simulation evidence

The original `Molybdenum/Prototype_1/IdVd_IdVg_clean.log_des.log` ends with a completed curve trace and reports drain = 10 V, gate = -2 V at the final point. This is evidence of that archived run completing, not independent validation or a new execution.

`Molybdenum/Prototype_1/n2_des.err` reports that excluding touching contact portions reduced source elements from 92 to 22, gate elements from 192 to 48, and drain elements from 92 to 22. These messages require geometric inspection; solver completion alone does not establish physically correct contacts.

`GAA/n2_des.err` reports a missing/unrecognized `sdemodel_msh.tdr`. The device electrode names also do not match the source's `SourceContact`, `DrainContact`, and `GateContact` labels.

The recovered `GAAJFET` temporary-session device error reports a non-existing `source` contact. That variant has an oxide-separated gate and is retained as an earlier experiment.

## Preparation checks

- Original files listed in `source-manifest.json` are copied byte-for-byte.
- Two selected current files were parsed as DF-ISE text: 74 output points and 51 transfer points, with 25 columns each.
- All parsed numbers are finite and complete; CSV export preserves all values to Python's float round-trip precision.
- The transfer data holds drain bias at 10 V; the output data holds gate bias at 0 V. Source bias is zero in both.
- No Sentaurus run, mesh regeneration, device calibration, or independent convergence study was performed.

## Provenance limits

The preserved mesh and geometry originate from the same prototype directory, but their correspondence has not been re-established by regeneration. Do not assume the saved mesh tracks subsequent geometry edits. Duplicate plots and alternate run outputs were not combined into a single claimed experiment.
