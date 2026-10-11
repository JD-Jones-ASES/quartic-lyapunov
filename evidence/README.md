# Exact evidence

Run the complete finite evidence suite with:

```sh
python -m pip install -r requirements.txt
python scripts/verify_evidence.py
```

The runner checks the source contract and pinned metadata schema, exercises
the clean-candidate guard normally and under `python -O`, and runs all six
replays both normally and under `python -O`. Logs, exit codes and source
hashes are written to `.lake/verification/evidence/`. The Linux verification
workflow runs this same suite before the full Lean build, axiom audit,
Lean mutation controls and independent-kernel replay.

| Replay | Exact finite coverage |
| --- | --- |
| `endpoint_certificate.py` | Endpoint reconstruction with SymPy rational algebraic-field arithmetic. |
| `independent_replay.py` | Separate standard-library `Fraction` reconstruction, checked modular inverses, Lie-map derivation and corruption controls. |
| `verify_semantics.py` | Actual quartic derivatives, quarter-turn, contraction identities and all-parameter Lie-map rank. |
| `verify_quadratic_boundary.py` | General-damping quadratic witness, dual recurrences and elimination identity. |
| `verify_sextic_certificate.py` | Actual sextic derivative at `b=9/4`, both Gram identities, exact positive leading minors and SOS decompositions. |
| `verify_all_degree_identities.py` | Algebraic identities supporting the written all-degree argument and the rational example at `b=3`. |

The sextic replay requires both `sextic_certificate.json` and
`sextic_sos.json`; a missing file fails verification. It checks the JSON
coefficients, derivative, matrices and recorded minors against exact
arithmetic. It reconstructs the SOS Gram matrices from rational coefficient
rows and weights; displayed form strings are compared as data and never
executed. Deliberate controls alter the sextic coefficient, derivative,
field parameter, Gram entries, recorded minor, SOS weight and SOS form.
A separate Gram mutation leaves the polynomial unchanged while making its
matrix indefinite, ensuring that positivity checks are independently needed.
Missing-file controls also exercise the mandatory-data check. All checks
remain active under optimized Python.

The candidate guard uses an isolated temporary Git repository to verify that
modified, staged, deleted and untracked sources are rejected, while a clean
commit and ignored generated output are accepted. It does not require a clean
working tree for these finite replays. Authoritative kernel verification
requires a clean candidate through `scripts/verify_kernels.py`.

`python scripts/generate_endpoint.py` emits real algebraic values,
polynomial identities and exact rational interval proofs; `lake build`
checks those proofs in Lean. Python results are not theorem premises. These
finite replays do not establish the analytic contraction or all-degree
existence arguments, Lean compilation, or exact-commit Linux verification.
