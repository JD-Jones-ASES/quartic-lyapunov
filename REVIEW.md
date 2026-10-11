# GPT Pro review brief

Review this private candidate before any public release or Palomar submission.
Read the [Challenge](QuarticLyapunovChallenge.lean), [proof](Proof.md),
[source audit](docs/Sources.md), [formal architecture](IMPLEMENTATION.md),
[verification record](VERIFICATION.md) and [disclosure](Disclosure.md).

The central claim is a complete classification over every real parameter and
all five arbitrary real quartic coefficients. Weak feasibility includes the
unique algebraic endpoint; strict feasibility excludes it. All inequalities
are quantified over every nonzero real pair. The coefficient formulas and
actual derivative semantics are explicitly compared.

Please examine:

1. Whether the formal contract matches the standard mathematical meaning of
   positive definite homogeneous quartic Lyapunov certificates.
2. The root definition, exact primal/dual construction, positivity, and the
   equality argument forcing one positive coefficient ray.
3. The quartic factorization and maximum-principle contraction, especially
   zero-freeness, the phase map, derivative signs, and inclusion of parameter zero.
4. The source relationship, bounded overlap audit, and research significance
   beyond the already published stability and all-degree obstruction.
5. Useful extensions that can be proved without diluting the full classification.

The signed-parameter classification is formalized via a quarter-turn. The
rational example at parameter two separates strict quartics from even weak
quadratics. General damping, higher degrees, quantitative Poisson margins and
full ODE stability are outside the compared contract. Please distinguish any
suggested mathematical extension from an issue with the current theorem.
