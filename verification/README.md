# Verification inputs

`formalization-v0.4.schema.json` is the unmodified upstream schema from
[mathlib-initiative/formalization.yaml](https://github.com/mathlib-initiative/formalization.yaml/tree/99c678e569c7c4c0772db297c5ddd5e4c9b6322e),
revision `99c678e569c7c4c0772db297c5ddd5e4c9b6322e`. Its Apache-2.0
license is retained in [SCHEMA-LICENSE.txt](SCHEMA-LICENSE.txt); the
project MIT license does not replace that third-party license.

The workflow uses exact action pins and the official Palomar sandbox installer
at `d4e41c1d5b0d114c4859e6e5831dc6d3ad1d0d44`. Lean 4.35.0-rc3 bundles
the selected Comparator and independent kernel binaries. Their SHA-256
hashes and the candidate commit are saved in every verification run.
