# Verification

The compared contract contains **24 declarations: 10 theorems and 14 concrete
definitions**, listed in [comparator.json](comparator.json). It covers the
signed strict and weak quartic classifications, algebraic boundary isolation,
explicit endpoint coefficients, the full derivative-feasible endpoint cone,
cubic-square geometry, degree-preserving quartic contraction, and the exact
degree separations at $b=2$ and $b=9/4$.

The unrestricted-degree and local analytic classification, quantitative degree
bound, all-damping quadratic classification, rational certificate at $b=3$,
and interval-wide sextic claims remain written supplements. Their finite
algebraic replays do not verify the analytic arguments.

## Exact release identity

Linux verification is tied to one exact commit. The
[verification workflow](https://github.com/JD-Jones-ASES/quartic-lyapunov/actions/workflows/verify.yml)
checks that commit in both the formal-verification and fresh-project-build
jobs. The annotated release marker `verified-v0.2.0` is created only after
both jobs pass. Its annotation records the full commit SHA and successful
run URL, identifying the verified source and its evidence.

The formal gate checks the complete Lean build, Comparator statement and
definition equivalence, permitted axioms for the compared declarations and
supporting proof closure, and replay through Lean, NanoDa and con-ron. A
separate fresh runner rebuilds all project sources without project build
artifacts. Dependency caches use the pinned Mathlib revision.

The only permitted axioms are `propext`, `Classical.choice` and `Quot.sound`.
The Solution imports no mathematical placeholders; Challenge placeholders
specify statements for comparison and import only Mathlib.

## Reproduction

```sh
python -m pip install -r requirements.txt
python scripts/verify_evidence.py
lake build
python scripts/audit_axioms.py
python scripts/check_lean_negative_controls.py
```

The evidence runner checks source hygiene and metadata, then replays the
endpoint certificates, polynomial semantics, quadratic identities, sextic
certificate and all-degree algebraic identities in ordinary and optimized
Python. It records results and source hashes under `.lake/verification/`.
Negative controls require altered certificates to fail their checks.

On the configured Linux runner, `python scripts/verify_kernels.py` performs
Comparator and independent-kernel replay. The workflow retains logs and
machine-readable results for the exact source commit. Finite Python checks
are supplementary evidence, not assumptions of the Lean proofs.
