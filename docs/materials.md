# Material parameter setup

The archives include Synopsys material tables whose headers explicitly restrict reproduction and distribution. The repository omits `Silicon.par`, `SiO2.par`, `Oxide.par`, `PolySilicon.par`, `Molybdenum.par`, and expanded `pp*_des.par` files containing their contents.

The small project-level `sdevice.par` wrappers are retained to document original includes. They cannot resolve those includes until the corresponding files are supplied from your licensed installation in your local run directory. Never commit those vendor tables.

The main wrapper lists SiO2, Molybdenum, and Silicon, although the main geometry creates only Silicon regions. Inspect the actual mesh materials before selecting parameters. Neither a material include nor an archive name establishes the physical presence of that material in the device.

The original main device deck has no explicit `Parameter` entry. Confirm whether your Workbench setup injects parameter settings; for a standalone run, configure the intended parameter file using your installed Sentaurus documentation. Substituting installation defaults may change results relative to the archived run.
