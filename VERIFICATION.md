# Verification

Review candidate prepared October 11, 2026. The full local Lean build,
148-declaration permitted-axiom audit, exact replays, metadata validation and
three Lean mutation controls pass.

Linux verification is tied to an exact commit. The
[verification workflow](https://github.com/JD-Jones-ASES/quartic-lyapunov/actions/workflows/verify.yml)
records that SHA in both its formal-verification and fresh-project-build jobs.
The annotated `verified-v0.1.0` tag is created only after both jobs pass; its
message records the full commit and run URL. This tag and the matching run,
rather than a build on another commit, identify the verified review candidate.

The compared contract contains eight mathematical statements and ten concrete
definitions. It covers the signed strict and weak classifications, the exact
algebraic boundary and its rational isolation, explicit endpoint coefficients,
complete endpoint uniqueness, cubic-square geometry, degree-preserving
contraction and the rational quartic/quadratic separation. No mathematical
placeholder is imported by the Solution. Challenge theorem placeholders serve
only to specify the statements for Comparator.

The endpoint proof uses generated polynomial identities and rational interval
bounds checked by Lean. The contraction is proved through real polynomial
factorization and the complex maximum principle. All supporting theorems and
compared declarations are included in the transitive permitted-axiom audit.

Reproduce with:

```sh
python -m pip install -r requirements.txt
python scripts/check_sources.py
python evidence/endpoint_certificate.py
python -O evidence/endpoint_certificate.py
python evidence/independent_replay.py
python -O evidence/independent_replay.py
lake build
python scripts/audit_axioms.py
python scripts/check_lean_negative_controls.py
```

The independent Python and primary SymPy endpoint replays check finite
algebraic evidence; they are not assumptions of Lean theorems. The Linux
workflow adds Comparator, Lean, NanoDa and con-ron replay, plus a separate
fresh project build, all on the exact selected commit. Mathlib dependency
caches are pinned; project build products are not reused in the fresh job.

Policy checked against PalomarPolicy `96b034cc31a72a63d4f4041911dce337a85c9a04`
and PalomarSubmission `d4e41c1d5b0d114c4859e6e5831dc6d3ad1d0d44`.
Metadata schema v0.4 is from formalization.yaml revision
`99c678e569c7c4c0772db297c5ddd5e4c9b6322e`.

This is a private review candidate. Submission, registration, worldwide
priority and human specialist review are separate and unclaimed.
