# Contraction and fixed-degree feasibility intervals

The general-degree results here are written analytic theorems, outside the
compared Lean contract; quartic contraction at damping one is formalized.

For

```math
f_{a,b}=(-aR+b(x^2-y^2))(x,y)+R(-y,x),\qquad R=x^2+y^2,
```

fix $a>0$ and an integer $N\ge1$. Let $W_N(a)$ be the set of $b\ge0$
admitting a positive definite real homogeneous polynomial of degree $2N$
with nonpositive Lie derivative. Define $S_N(a)$ using strictly negative
derivative instead. Set $C(a)=(1+a^{2/3})^{3/2}$.

## Every fixed degree has one attained boundary

There exists $B_N(a)$ such that

```math
a\le B_N(a)<C(a),\qquad
W_N(a)=[0,B_N(a)],\qquad S_N(a)=[0,B_N(a)).              \qquad (1)
```

**Proof.** The radial polynomial $R^N$ works weakly for $0\le b\le a$ and
strictly for $0\le b<a$. The
[contraction lemma](../Proof.md#2-one-weak-certificate-gives-strict-certificates-below-it)
turns a weak certificate at positive $b$ into strict certificates at all
smaller nonnegative parameters. The necessity argument in the
[all-degree theorem](AllDegreeClassification.md#3-necessity-the-quadrant-map-bound-is-strict)
bounds every weak-feasible parameter by $b<C(a)$.

Let $B=\sup W_N(a)$, which is finite and positive. To prove endpoint
attainment, take feasible $b_j\to B$ and normalize their angular traces
$p_j$ to have mean one. Every Fourier coefficient has absolute value at
most one because $p_j>0$. In the fixed finite-dimensional space of
trigonometric polynomials of degree at most $N$, a subsequence converges
coefficientwise, hence in $C^1$, to a nonnegative trace $p$ with mean one.
It satisfies

```math
p'+N(-a+B\cos t)p\le0.                                \qquad (2)
```

If $p(t_0)=0$, then

```math
E(t)=\exp\big(N[-a(t-t_0)+B(\sin t-\sin t_0)]\big)p(t)
```

is nonnegative, $E(t_0)=0$, and $E'\le0$. It vanishes on
$[t_0,t_0+2\pi]$, contradicting the mean-one normalization. Thus $p>0$,
and it lifts to a positive definite degree-$2N$ homogeneous polynomial.
This proves weak endpoint attainment, and the all-degree obstruction then
gives $B<C(a)$.

A strict certificate persists under a sufficiently small change in $b$:
its angular derivative margin has a positive minimum, while the perturbation
is bounded by $N|\Delta b|\max p$. Therefore the largest feasible parameter
cannot be strict. Contraction supplies strictness everywhere below it. This
proves (1).

Powers give $B_{kN}(a)\ge B_N(a)$ for positive integers $k$: raising a
positive certificate to an integral power preserves its derivative sign.
No monotonicity between arbitrary consecutive degrees is asserted. The
[quantitative degree bound](QuantitativeDegreeBound.md) proves
$B_N(a)\to C(a)$ with an explicit convergence estimate.

## Quantitative margin and robustness

If $V_0$ is weak at $B_0>0$ and $V_\rho$ is its outer-factor contraction,
then for $z\ne0$ and $0\le\rho<1$ the main proof gives

```math
-\mathcal L_{f_{a,\rho B_0}}V_\rho(z)
\ge 2Na\frac{1-\rho}{1+\rho}\,\|z\|^2 V_\rho(z).        \qquad (3)
```

Since $V_\rho$ has a positive minimum $m_\rho$ on the unit circle, the
left side is at least
$2Na(1-\rho)m_\rho\|z\|^{2N+2}/(1+\rho)$. This proves robustness to
sufficiently small coefficient perturbations among homogeneous cubic vector
fields, equivalently perturbations bounded by $\varepsilon\|z\|^3$.
No uniform lower bound for $m_\rho$ as $\rho\to1$ is needed.

The [quadratic boundary](QuadraticBoundary.md) determines $B_1(a)$ for
every $a>0$, and the [quartic theorem](../Proof.md) determines $B_2(1)$.
Exact $B_2(a)$ at arbitrary damping and the higher-degree boundaries remain
undetermined, although their all-degree limit is known.
