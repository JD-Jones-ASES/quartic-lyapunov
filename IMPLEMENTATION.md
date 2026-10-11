# Formalization plan

The intended final contract uses all five arbitrary real quartic coefficients,
positivity at every nonzero real pair, and the actual derivative along the
specified cubic field. The boundary is the isolated positive algebraic root
of the displayed degree-twelve equation, with equivalence to the unique
root above one of the degree-six equation in its square.

1. Define polynomial semantics and prove the gradient bridge.
2. Prove algebraic root existence, uniqueness and rational isolation.
3. Check the endpoint cubic-square identity and positive quartic certificate.
4. Build the three-atom dual and classify its equality case.
5. Prove degree-preserving contraction, or an independently justified finite
   algebraic replacement that covers the entire parameter continuum.
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

Current completion evidence and remaining work belong in
[VERIFICATION.md](VERIFICATION.md).
