# Sources and overlap audit

Audit date: October 11, 2026. This is a bounded literature and formalization
search, with the literal theorem as the comparison unit. Worldwide priority
and human specialist review remain unestablished.

| Source | Established contribution | Relationship to this project |
| --- | --- | --- |
| [Liu and Fitzsimmons, arXiv:2607.16171v1](https://arxiv.org/html/2607.16171v1), Section IV.D and Theorem IV.3 | The displayed two-parameter cubic family is globally asymptotically stable for positive damping; no positive definite homogeneous polynomial has weak derivative when the absolute parameter is at least twice damping plus two. | Supplies the family and all-degree context. At damping one its exclusion begins at 4; it does not state the exact quartic boundary near 2.12815. Lemma III.2 supplies the classical outer-factor argument used in the written contraction proof. |
| [Ahmadi and Parrilo, arXiv:1308.6833](https://arxiv.org/html/1308.6833), Theorems 4.3–4.4 | Other planar cubic families exhibit unbounded required degree and failure of monotonicity between quartic and sextic certificates. | Establishes why certificate degree matters. The family, quantifiers and boundary differ. Remark 4.2 labels its displayed parameter interval numerical. |
| [Ahmadi and El Khadir, arXiv:1803.01877](https://arxiv.org/abs/1803.01877) | Rational Lyapunov converse results and an SOS framework for homogeneous fields. | Background on algebraic stability certificates, rather than this quartic classification. |
| [Liu's formalization README](https://github.com/j49liu/homogeneous-lyapunov-counterexample-lean) | Reports formalization of the fixed counterexample with damping one and parameter five. | Metadata-only comparison. No proof implementation was imported or independently replayed. Its advertised result differs from the all-parameter degree-four classification here. |

The proposed original contribution is the exact strict/weak quartic boundary,
its unique endpoint ray, and explicit degree separation in this published
family. The accompanying [proof](../Proof.md) is an original proof document
for this development. The cited source theorem is background, not the theorem
claimed to have been formalized here.

Searches covered the exact arXiv identifier with “quartic” and “classification,”
the author names with quartic/homogeneous/boundary, the numerical endpoint,
“homogeneous Lyapunov quartic exact boundary,” “quartic Lyapunov Fejer
contraction,” and GitHub-indexed quartic Lyapunov classifications. The exact
family paper, its two primary antecedents above, and the reported formalization
scope were inspected. No inspected source stated the same classification.
Search-engine indexing and the public catalogue are incomplete; this finding
is not a proof of novelty or absence of unpublished overlap.

The relevant audience is researchers in polynomial dynamical systems,
nonlinear control, real algebraic geometry and exact semidefinite certificates.
The result resolves a complete finite-degree parameter slice with arbitrary
real coefficients, and distinguishes weak endpoint attainment from strict
feasibility. It does not reprove the source's full global asymptotic stability
or classify every degree or variable damping.

A supplementary catalogue scan used public GitHub repository descriptions for
“quartic lyapunov” and “lyapunov lean,” and web-indexed Palomar entries. The
former returned only this newly created repository; the latter returned a
generic Lyapunov repository. These searches do not cover every public project.
No implementation files from those projects were read.

[Quartic Lyapunov functions for global fluid stability](https://arxiv.org/abs/2606.18232v1)
by Darrow, Carlson and Goluskin was checked at the abstract level as a nearby
2026 result. It treats fluid shear-flow certificates and parameter ranges,
not this planar cubic ODE or its exact five-coefficient quartic threshold.
The topical similarity does not establish an application of this theorem to
fluid stability.
