# Formal architecture

The contract quantifies over all five real quartic coefficients and every
nonzero real pair. Polynomial evaluation and Lie derivatives are concrete
definitions; gradient identities connect them to the displayed cubic field.
The algebraic boundary is specified by its polynomial equation and rational
isolating interval.

| Modules | Role |
| --- | --- |
| `Basic`, `Root`, `Interval`, `ExplicitEndpoint` | Polynomial semantics, the actual gradient bridge, algebraic root isolation and explicit endpoint coefficients. |
| `EndpointData`, `EndpointIdentities`, `EndpointSigns`, `Endpoint`, `CubicRoots` | Exact endpoint identities, positivity and three distinct real derivative-zero lines. |
| `AtomicDual`, `LieMap`, `EndpointUnique`, `EndpointCone` | Three-atom obstruction, injectivity and the complete nonnegative endpoint coefficient ray without an assumed sign for the quartic. |
| `Factorization`, `SpectralFactors`, `SpectralDerivative`, `PositiveReal`, `Contraction` | Degree-preserving quartic contraction and strict interior positivity. |
| `Classification`, `Application`, `SexticApplication` | Signed classification and explicit degree separations at two and nine-fourths. |

The quartic contraction proof derives two positive quadratic factors from
Mathlib's real polynomial factorization. Their outer linear factors are
contracted radially. The spectral derivative identity and complex maximum
principle then give the strict actual Lie inequality. This formalizes the
degree-four, damping-one specialization of the
[written contraction argument](Proof.md#2-one-weak-certificate-gives-strict-certificates-below-it).

The [Challenge](QuarticLyapunovChallenge.lean) imports only Mathlib.
The [Solution](QuarticLyapunovSolution.lean) exposes ten theorem contracts;
[comparator.json](comparator.json) also compares fourteen concrete definitions,
including the sextic evaluation, Lie derivative and certificate predicates.
The supporting formal proofs lie in [QuarticLyapunov](QuarticLyapunov).

General even-degree contraction, the all-degree analytic classification,
quantitative degree bounds and the all-damping quadratic boundary are written
supplements. Their functional analysis and measure approximation are outside
the Lean contract. [Verification](VERIFICATION.md) records the mechanical
checks for the formal source.
