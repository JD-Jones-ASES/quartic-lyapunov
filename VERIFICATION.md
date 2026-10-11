# Verification status

Development checkpoint, October 11, 2026. This is an incomplete formalization
of the full classification. No Linux release gate or Palomar submission has run.

Locally checked with pinned Lean 4.35.0-rc3 and Mathlib:

- Actual partial derivatives and the polynomial Lie-derivative bridge.
- Existence, rational isolation and uniqueness of the algebraic boundary.
- Strict rational quartic at parameter two and exclusion of every weak
  positive definite homogeneous quadratic there.
- All seven endpoint cubic-square coefficient identities; all five dual
  annihilation identities; exact moment normalization.
- Exact rational interval proofs of endpoint positive Gram pivots and
  the cubic's signs in three disjoint rational intervals.
- Positive definiteness and weak feasibility of the explicit endpoint quartic.
- Positive three-atom dual, strict exclusion and full weak endpoint-ray uniqueness.
- Factorization of every positive quartic into two positive quadratic factors.
- Complex maximum-principle positivity used by the contraction proof.

The local complete build and transitive permitted-axiom audit pass for the
current endpoint and application contract. Contraction over the complete
parameter interval, final iff contracts, statement comparison and exact-commit
Linux kernel replay remain to be completed.

The independent Python and primary SymPy endpoint replays check finite
algebraic evidence. They are not assumptions of Lean theorems and do not
verify the analytic contraction argument. Build logs from development do not
substitute for the exact-candidate release evidence.
