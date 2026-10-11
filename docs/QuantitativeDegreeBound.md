# Quantitative degree bounds and convergence of every degree threshold

This is a written analytic theorem, outside the compared Lean contract.
It gives an explicit degree bound using the positive boundary measure from
the [all-degree classification](AllDegreeClassification.md).

Let

```math
C=C(a)=(1+a^{2/3})^{3/2},\qquad a>0.
```

For $0\le b<C$, put $\rho=b/C$. Then **every** integer $N\ge1$
satisfying

```math
\boxed{N\ge\frac{4\pi\rho}{a(1-\rho)^2}}
\qquad (1)
```

admits a positive definite homogeneous polynomial of degree $2N$ with
strictly negative Lie derivative for $f_{a,b}$. Negative parameters follow
by the quarter-turn conjugacy. The estimate supplies a degree upper bound;
it does not assert minimality.

In particular, every sufficiently large even degree admits a strict
certificate at each parameter inside the all-degree boundary.

## 1. Equal weights with an explicit discrepancy bound

Use the positive probability measure $\mu$ supplied by the all-degree
proof at the relaxed boundary parameter $b_0=C$. Identify the circle with
angles in $[0,2\pi)$, including any atom at the cut in the usual
right-continuous cumulative distribution function $F$.

For $j=1,\ldots,N$, choose the generalized quantile

```math
t_j=F^{-1}\left(\frac{j-1/2}{N}\right),
\qquad
\mu_N=\frac1N\sum_{j=1}^N\delta_{t_j}.
```

Repeated quantiles are allowed. If $F_N$ is the cumulative distribution
function of $\mu_N$, then

```math
\sup_t|F_N(t)-F(t)|\le\frac1{2N}.
\qquad (2)
```

Indeed, $NF_N(t)$ counts the half-integers $j-1/2$ that are at most
$NF(t)$; nearest-integer rounding has error at most $1/2$.
This argument accommodates atoms of arbitrary mass.

For every complex-valued continuously differentiable periodic function $g$,
Stieltjes integration by parts and equality of total mass give

```math
\left|\int g\,d(\mu_N-\mu)\right|
\le\frac1{2N}\int_0^{2\pi}|g'(t)|\,dt.
\qquad (3)
```

One can equivalently use the distribution functions of the measures on
$[0,2\pi]$ with no mass at $2\pi$. The difference has total mass zero,
so the boundary term vanishes; the possible atom at zero is included in the
Stieltjes formula.

## 2. Uniform kernel error

For $|z|\le1$, use

```math
K_\rho(t,z)=\frac{1+\rho e^{it}z}{1-\rho e^{it}z}.
```

Writing $s=\rho|z|<1$, direct differentiation and the Poisson-kernel
integral give

```math
\begin{aligned}
\int_0^{2\pi}|\partial_tK_\rho(t,z)|\,dt
&=2s\int_0^{2\pi}\frac{dt}{1-2s\cos t+s^2}\\
&=\frac{4\pi s}{1-s^2}
\le\frac{4\pi\rho}{1-\rho^2}.
\end{aligned}
\qquad (4)
```

Define $P_\rho$ using $\mu$, and define $P_N$ using the quantile
measure $\mu_N$, exactly as in the all-degree proof. Equations (3)–(4)
show

```math
\boxed{\sup_{|z|\le1}|P_N(z)-P_\rho(z)|
\le\frac{2\pi\rho}{N(1-\rho^2)}.}
\qquad (5)
```

The original positive measure $\nu$, of mass $a$, gives the strict
Poisson margin

```math
\operatorname{Re}F_\rho(z)\ge
\delta=a\frac{1-\rho}{1+\rho}>0.
```

Under condition (1), the right side of (5) is at most $\delta/2$.
Consequently, with $F_N=a-i-bz+iP_N$,

```math
\operatorname{Re}F_N(z)\ge\frac\delta2>0
\qquad(|z|\le1).
```

The explicit finite product

```math
Q_N(z)=\prod_{j=1}^N(1-\rho e^{it_j}z)
```

and its degree-$N$ homogenization supply a positive definite homogeneous
polynomial $V_N$ of degree $2N$, with

```math
-\mathcal L_{f_{a,b}}V_N(z)
\ge Na\frac{1-\rho}{1+\rho}\,\|z\|^2V_N(z)
\qquad(z\ne0).
\qquad (6)
```

The factor in (6) is $2N$ times the retained margin $\delta/2$.
For $b=0$, the same construction yields a positive multiple of $R^N$,
and all statements remain valid.

## 3. Every fixed-degree boundary converges to the all-degree boundary

Let $B_N(a)$ be the attained weak boundary for degree $2N$, as in the
[fixed-degree theorem](Extensions.md). Put

```math
k_N=\frac{2\pi}{aN},\qquad
r_N=1+k_N-\sqrt{k_N^2+2k_N}
=\frac1{1+k_N+\sqrt{k_N^2+2k_N}}.
\qquad (7)
```

Here $0<r_N<1$, and

```math
N=\frac{4\pi r_N}{a(1-r_N)^2}.
```

Thus (1) supplies a **strict** degree-$2N$ certificate at
$b=C(a)r_N$. Strict feasibility is open in $b$, so the exact boundary
satisfies

```math
C(a)r_N<B_N(a)<C(a).
\qquad (8)
```

The right inequality is the all-degree obstruction combined with fixed-degree
endpoint attainment. Since

```math
1-r_N=\sqrt{k_N^2+2k_N}-k_N<\sqrt{2k_N},
```

we obtain the explicit convergence bound

```math
\boxed{0<C(a)-B_N(a)<2C(a)\sqrt{\frac{\pi}{aN}}.}
\qquad (9)
```

In particular,

```math
\boxed{\lim_{N\to\infty} B_N(a)=C(a).}
```

No monotonicity between consecutive degrees is used or claimed. The existing
radial lower bound $B_N(a)\ge a$ can be combined with (8) when the displayed
quantitative bound is numerically weak. The constants are explicit sufficient
bounds obtained from a simple quantile construction; no optimal convergence
rate is asserted.

The finite product is specified by quantiles of a representing measure whose
existence follows from Hahn–Banach and Riesz representation. The proof does
not compute that measure, so the degree bound alone is not a certificate
generation algorithm.
