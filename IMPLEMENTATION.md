# Formal architecture

The final contract uses all five arbitrary real quartic coefficients,
positivity at every nonzero real pair, and the actual derivative along the
specified cubic field. The boundary is the isolated positive algebraic root
of the displayed degree-twelve equation, with equivalence to the unique
root above one of the degree-six equation in its square.

1. Define polynomial semantics and prove the gradient bridge.
2. Prove algebraic root existence, uniqueness and rational isolation.
3. Check the endpoint cubic-square identity and positive quartic certificate.
4. Build the three-atom dual and classify its equality case.
5. Prove degree-preserving contraction using two positive quadratic factors
   and the complex maximum principle over the unit disk.
6. Conclude both strict and weak if-and-only-if statements and endpoint uniqueness.
7. Include the exact rational degree-separation application and useful proved
   extensions in the compared contract.
8. Verify the exact candidate on Linux with statement comparison, permitted
   axioms, independent kernels and a fresh build before the review handoff.

The classification must not acquire extra certificate hypotheses, symmetry
restrictions or sampling qualifications during implementation. The primary
analytic dependency is outer-factor contraction, detailed in [Proof.md](Proof.md).
A polynomial coefficient map alone is insufficient without the actual
Lie-derivative bridge. General ODE stability is outside the initial contract.

All mathematical stages above are implemented. Release verification evidence belongs in
[VERIFICATION.md](VERIFICATION.md).

The degree-four contraction is implemented without assuming Fejér–Riesz:
`Factorization.lean` derives two positive quadratic factors using Mathlib's
real polynomial factorization. `SpectralFactors.lean` constructs their outer
linear factors and contracts them radially. `SpectralDerivative.lean` proves
the exact identity with the actual polynomial Lie derivative.
`PositiveReal.lean` derives strict interior real-part positivity from the
complex maximum principle, and `Contraction.lean` combines these steps.
This is a specialization of the written outer-factor argument. The general
even-degree and quantitative Poisson-bound supplements remain written results.
