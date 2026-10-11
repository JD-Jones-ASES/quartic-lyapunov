# Sources and theorem scope

[Liu and Fitzsimmons, arXiv:2607.16171v1](https://arxiv.org/abs/2607.16171v1),
Section IV.D and Theorem IV.3, introduce the displayed two-parameter cubic
family. They prove global asymptotic stability for positive damping and
exclude positive definite homogeneous polynomial weak certificates when
$|b|\ge2(a+1)$. Lemma III.2 supplies the outer-factor argument used in the
written contraction proof. Their Section IV.C gives a rational certificate
at parameter five; [IntegerCounterexample](IntegerCounterexample.md) adapts
that construction to parameter three.

This repository proves the exact signed quartic boundary at damping one,
its full derivative-feasible endpoint cone, and explicit degree separations
at two and nine-fourths in Lean. The written
[all-degree classification](AllDegreeClassification.md) gives the sharper
criterion $|b|<(1+a^{2/3})^{3/2}$ for positive damping, also equivalent to
local real-analytic weak feasibility. The written
[quadratic classification](QuadraticBoundary.md) treats every positive damping.
These statements have different scope from the source obstruction and the
source's global stability theorem.

Further background:

- [Ahmadi and Parrilo, arXiv:1308.6833](https://arxiv.org/abs/1308.6833),
  Theorems 4.3–4.4, exhibit other planar cubic families with unbounded
  certificate degree and failure of monotonicity between quartic and sextic
  feasibility. Their families and parameter statements differ from these.
- [Ahmadi and El Khadir, arXiv:1803.01877](https://arxiv.org/abs/1803.01877)
  gives rational Lyapunov converse results and an SOS framework for
  homogeneous fields.
- [Liu's formalization](https://github.com/j49liu/homogeneous-lyapunov-counterexample-lean)
  reports the fixed damping-one, parameter-five counterexample. This is a
  comparison of its stated scope; its implementation is not an input here.

A bounded search of the cited literature and indexed formalizations found no
matching exact classification. This does not establish worldwide priority or
exclude unpublished overlap.
