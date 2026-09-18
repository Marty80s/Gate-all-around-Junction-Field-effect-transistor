# Gate-All-Around JFET — Sentaurus TCAD

A three-dimensional silicon nanowire junction field-effect transistor prototype developed with **Synopsys Sentaurus Structure Editor and Sentaurus Device**. The project explores a cylindrical n-type channel surrounded by a p-type silicon gate shell, with saved drain-voltage and gate-voltage sweep data.

The repository contains the original simulation decks, the main prototype's saved mesh, two earlier geometry variants, and a dependency-free Python utility for exporting the archived electrical results to CSV.

**Status:** research prototype with historical simulation outputs. The main archived run reached the end of its curve trace, but the device has not been independently calibrated or rerun during repository preparation. Contact assignment, mesh convergence, and extremely small simulated currents need further investigation.

## Start here

```bash
git clone https://github.com/Marty80s/Gate-all-around-Junction-Field-effect-transistor.git
cd Gate-all-around-Junction-Field-effect-transistor
```

- Main device and simulation decks: [`device/`](device/)
- Saved curves: [`results/raw/`](results/raw/)
- Portable CSV data: [`results/csv/`](results/csv/)
- Provenance and known issues: [`docs/validation.md`](docs/validation.md)
- Reproduction instructions: [Running the project](#running-the-project)

## Device concept

The intended structure consists of an n-type silicon channel, n+ source and drain extensions, and a surrounding p+ silicon gate. Applying reverse bias to the gate–channel junction changes channel depletion and controls conduction. This junction-gate design has no intervening gate oxide in the main geometry.

The source archive was named `Molybdenum`, but **the included main geometry creates only silicon regions**. A `Molybdenum.par` reference in a parameter wrapper does not establish the presence of a molybdenum gate. This repository therefore describes the main prototype as a silicon GAA JFET.

### Main geometry and doping

Dimensions below come directly from `device/sde_dvs.cmd`. Geometric coordinates are in micrometers; doping concentrations are in cm⁻³.

| Parameter | Value | Meaning |
| --- | ---: | --- |
| Channel radius, `Rch` | 0.05 µm / 50 nm | Silicon core radius |
| Gate shell thickness, `tgate` | 0.01 µm / 10 nm | Radial thickness of p+ silicon shell |
| Outer gate radius | 0.06 µm / 60 nm | Channel radius plus shell thickness |
| Channel length, `Lch` | 0.50 µm / 500 nm | Gated section along x |
| Source extension, `Lsd` | 0.05 µm / 50 nm | Left extension |
| Drain extension, `Lsd` | 0.05 µm / 50 nm | Right extension |
| Total axial length | 0.60 µm / 600 nm | Source + channel + drain |
| Channel donors | 1 × 10¹⁸ cm⁻³ | Phosphorus active concentration |
| Source/drain donors | 1 × 10¹⁹ cm⁻³ | Phosphorus active concentration |
| Gate acceptors | 1 × 10¹⁹ cm⁻³ | Boron active concentration |

The source spans x = 0–0.05 µm, the channel and gate span 0.05–0.55 µm, and the drain spans 0.55–0.60 µm. The geometry creates the larger gate cylinder before the channel cylinder and relies on overlap handling to leave an annular gate. Verify the resulting regions in Structure Editor rather than relying on the source comments alone.

## What is included

| Directory | Purpose |
| --- | --- |
| `device/` | Main prototype: geometry deck, device deck, material include wrapper, mesh commands, boundary and mesh TDR files |
| `archive/gaa-initial/` | Early geometry without doping; archived run had a missing-mesh error |
| `archive/gaa-oxide/` | Earlier oxide-separated gate variant; archived run had a missing-contact error |
| `results/raw/` | Two original DF-ISE text current files, renamed for clarity |
| `results/csv/` | All columns converted to CSV, plus a numerical summary |
| `docs/` | Validation notes, material setup, and source checksums |
| `tools/export_curves.py` | Standard-library Python converter; no Sentaurus license needed |

Original decks and selected raw data are preserved byte-for-byte. See [`docs/source-manifest.json`](docs/source-manifest.json) for exact source paths and SHA-256 hashes. Generated caches, temporary sessions, GUI preferences, duplicate curves, bulk logs, and vendor material tables are excluded.

## Simulation configuration

The main `sdevice_des.cmd` enables:

- Doping-dependent mobility, high-field saturation, and `Enormal` mobility treatment.
- Old Slotboom band-gap narrowing.
- Shockley–Read–Hall and Auger recombination.
- Coupled Poisson, electron, and hole equations.
- Quasistationary bias stepping with extrapolation, relative error control, and an iteration limit of 50.
- `ExcludeTouchingContactParts`, which changes the active contact elements when contact regions touch.

These are the settings present in the source, not a claim that they are optimal or calibrated for this geometry. The deck has no explicit avalanche-generation model; its high-drain-bias sweep must not be presented as a breakdown characterization.

### Bias sequence

| Stage | Drain bias | Gate bias | Purpose |
| --- | --- | --- | --- |
| Initial coupled solve | 0 V | 0 V | Starting solution |
| Initial drain ramp | 0 → 0.05 V | 0 V | Bias initialization |
| Drain sweep, first segment | 0.05 → 6 V | 0 V | Output characteristic |
| Drain sweep, second segment | 6 → 10 V | 0 V | Continue output characteristic |
| Gate sweep | Held at 10 V | 0 → −2 V | Transfer characteristic |

The transfer curve is recorded at **VDS = 10 V**, not 0.1 V. Several other files in the original archive have different bias values in their names; this package uses the actual voltage columns and the matching `IdVd_jfet` / `IdVg_jfet` files.

## Archived results

These values were extracted from the supplied `.plt` files; they are not new simulations or measured device data.

| Curve | Saved points | Actual saved sweep range | Fixed terminal bias | Drain total-current range |
| --- | ---: | --- | --- | --- |
| ID–VD | 74 | VD = 0.07975 to 10 V | VG = VS = 0 V | 4.1012 × 10⁻¹³ to 1.1788 × 10⁻¹² A |
| ID–VG | 51 | VG = −0.02 to −2 V | VD = 10 V; VS = 0 V | 3.7348 × 10⁻¹⁸ to 5.4850 × 10⁻¹³ A |

The saved files begin after the first bias step, so their first points differ from the nominal ramp starting values. The DF-ISE `time` column is a quasistationary sweep coordinate, not a transient switching-time measurement. Current values are terminal currents as stored, without width normalization.

The very low current levels and contact exclusions make physical interpretation provisional. No validated on/off ratio, threshold voltage, subthreshold swing, breakdown voltage, or performance advantage is claimed.

## Running the project

### 1. Inspect data without Sentaurus

Requirements: Python 3.8 or later. From the repository root:

```bash
python3 tools/export_curves.py
```

This recreates `results/csv/idvd.csv`, `idvg.csv`, and `summary.json`. It checks the text format, complete row lengths, and finite numerical values. Every source column is retained, including gate/source currents and terminal charges.

### 2. Configure the TCAD environment

You need licensed installations of Sentaurus Structure Editor, Sentaurus Mesh, Sentaurus Device, and optionally Sentaurus Visual. The source archives contain V-2024.03 session metadata; compatibility with other versions has not been tested.

Use your institution's supported environment setup. Confirm that `sde`, `sdevice`, and `svisual` are available. See [`docs/materials.md`](docs/materials.md) before configuring material parameter files.

### 3. Rerun the device solver with the saved mesh

Run in a separate working directory to preserve archived source and results:

```bash
mkdir -p runs/main
cp device/sdevice_des.cmd device/gaa_jfet_msh.tdr runs/main/
cd runs/main
sdevice sdevice_des.cmd
```

The supplied device deck does not explicitly name a `Parameter` file in its `File` block. This standalone command relies on your installation's material defaults and must be checked against the parameter handling in your Workbench setup. It is an invocation template, not a verified reproduction of the historical parameter environment.

The deck names the current prefix `IdVd_IdVg_clean.plt`, then uses `NewCurrentFile` to separate the drain and gate sweeps. Inspect the generated filenames and solver log; the archived outputs used `IdVd_jfetIdVd_IdVg_clean.plt` and `IdVg_jfetIdVd_IdVg_clean.plt`.

### 4. Rebuild or modify the geometry

Open `device/sde_dvs.cmd` in Structure Editor, preferably in a fresh session and a separate run directory. A batch invocation template is:

```bash
# From the repository root:
mkdir -p runs/geometry
cp device/sde_dvs.cmd runs/geometry/
cd runs/geometry
sde -e -l sde_dvs.cmd
```

Inspect the four silicon regions, annular gate, doping placement, and contact faces. Set the intended overlap behavior explicitly in your environment. The original script calls `sde:build-mesh` without an explicit filename and does not define a mesh-refinement strategy. Check its output name and explicitly export a mesh named `gaa_jfet_msh.tdr` before running the device deck against it.

Do not silently substitute the old saved mesh after changing geometry: the device solver must read the mesh generated from the new settings.

### 5. Inspect results

Use Sentaurus Visual to open the generated mesh/solution TDR and current PLT files. Inspect net doping, potential, carrier density, and contact topology, then plot drain total current against the actual drain or gate outer-voltage column. Use a logarithmic current axis when inspecting leakage-scale values.

## Earlier variants

| Variant | Important difference | Archived problem |
| --- | --- | --- |
| `gaa-initial` | 20 nm core radius, 100 nm channel; no doping profiles in the geometry source | Device deck expects `sdemodel_msh.tdr`, which was missing; contact labels also differ between geometry and device deck |
| `gaa-oxide` | 20 nm core, 5 nm oxide, 10 nm outer silicon shell, 100 nm channel | Device solver could not find contact `source` |
| Main silicon JFET | 50 nm core, 500 nm gated length, doped p+ silicon shell | Archived solve completes, but touching-contact parts were excluded |

The oxide-separated variant should not be interpreted as the same direct junction-gate device as the main prototype. Earlier decks are kept for project history and are not advertised as working examples.

## Verification and next steps

Repository preparation verified the source checksums and parsed all 125 saved curve points. It did not run Sentaurus, regenerate the mesh, or validate electrical performance.

Before reporting device metrics:

1. Inspect and correct contact faces, especially the gate–source and gate–drain boundaries.
2. Make geometry overlap rules and mesh output naming explicit.
3. Add junction and channel mesh refinements and perform a mesh-convergence study.
4. Confirm material parameters and physics choices for the intended operating regime.
5. Repeat transfer sweeps at clearly specified drain biases and verify solver tolerances at very small currents.
6. Validate against a trusted reference before interpreting extracted metrics as device performance.

## Attribution and licensing

Organized from the supplied `GAA.tar.gz`, `GAAJFET.tar.gz`, and `Molybdenum.tar.gz` archives. New repository documentation and the CSV exporter were added during preparation. No open-source license was supplied or assigned. Synopsys software and proprietary material parameter tables are not included; use a licensed local installation.
