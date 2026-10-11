# Contraction and fixed-degree feasibility intervals

Date: 2026-10-11. Written consequences of the [main proof](../Proof.md), with
classical analytic dependencies made explicit. No new all-degree threshold
or variable-damping quartic classification is asserted.

For f_{a,b}=(-aR+b(x²−y²))(x,y)+R(-y,x), a>0 and a positive integer N,
let W_N(a) be the set of b≥0 admitting a positive definite real homogeneous
polynomial of degree 2N with weak derivative. Define S_N(a) with strict
derivative instead.

## Every fixed degree has one attained boundary

There exists a number B_N(a) with

```math
a\le B_N(a)<2(a+1),\qquad
W_N(a)=[0,B_N(a)],\qquad S_N(a)=[0,B_N(a)).              \qquad (1)
```

**Proof.** The radial polynomial R^N works weakly for 0≤b≤a and strictly
for 0≤b<a. The contraction lemma in PROOF shows that a weak certificate
at any positive b gives strict certificates at all smaller nonnegative
parameters. Liu–Fitzsimmons Theorem IV.3 bounds every weak-feasible
parameter by b<2(a+1).

Let B=sup W_N(a), which is finite and positive by these observations.
It remains to justify endpoint attainment rather than silently assuming
that positive definiteness is a closed condition. Take feasible b_j→B,
normalize each angular trace p_j to have mean one, and note that every
Fourier coefficient has absolute value at most one because p_j>0. In the
fixed finite-dimensional space of trigonometric polynomials of degree at
most N, a subsequence converges coefficientwise, hence in C¹, to a
nonnegative trace p with mean one. It satisfies

```math
p'+N(-a+B\cos t)p\le0.                                \qquad (2)
```

If p(t₀)=0, then

```math
E(t)=\exp\big(N[-a(t-t_0)+B(\sin t-\sin t_0)]\big)p(t)
```

is nonnegative with E(t₀)=0 and E'≤0. It vanishes on [t₀,t₀+2π],
contradicting the mean-one normalization. Thus p>0, and it lifts to a
positive definite degree-2N homogeneous polynomial. This proves weak
endpoint attainment, and also proves that B cannot equal 2(a+1), where
the source theorem excludes it.

Finally a strict certificate persists under a small change in b: its
positive angular derivative margin has a positive minimum, while the
perturbation term is bounded by N|Δb|max p. Therefore the largest feasible
parameter cannot be strict. Contraction supplies strictness everywhere
below it. This proves (1). ∎

This result does not claim that the numbers B_N(a) are monotone in N.
Powers do give B_{kN}(a)≥B_N(a) for positive integers k: raising a positive
certificate to a positive integral power preserves its derivative sign.
A comparison between arbitrary consecutive degrees needs a separate proof.

## Quantitative margin and robustness

If V₀ is weak at B₀>0 and Vρ is its outer-factor contraction, the explicit
bound in the main proof gives, for z≠0 and 0≤ρ<1,

```math
-\mathcal L_{f_{a,\rho B_0}}V_\rho(z)
\ge 2Na\frac{1-\rho}{1+\rho}\,\|z\|^2 V_\rho(z).        \qquad (3)
```

Since Vρ is positive on the unit circle, it also has a positive minimum
mρ there. Hence the left side is at least
2Na(1−ρ)/(1+ρ) mρ ||z||^{2N+2}. This makes strictness robust to
sufficiently small coefficient perturbations within homogeneous cubic
vector fields (equivalently, perturbations bounded by ε||z||³).
No uniform bound on mρ as ρ→1 is claimed or needed.

For the classified quartic slice, N=2, a=1, B₀=B. Equations (1)–(3)
therefore sharpen a binary existence statement with an attained unique
boundary and a controlled interior derivative margin. The exact general
values B_N(a), including B_2(a) for a≠1, remain **UNKNOWN** here.
