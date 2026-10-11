# Exact quartic Lyapunov classification

## Theorem

Fix damping one. Put $R=x^2+y^2$ and

```math
f_b(x,y)=(-R+b(x^2-y^2))(x,y)+R(-y,x),\qquad b\ge0.
```

The coefficients of a candidate

```math
V(x,y)=v_0x^4+v_1x^3y+v_2x^2y^2+v_3xy^3+v_4y^4
```

are **arbitrary real numbers**. Positive definiteness means $V(x,y)>0$ for
all $(x,y)\ne(0,0)$; homogeneity gives $V(0,0)=0$. A weak certificate
has $\nabla V\cdot f_b\le0$ at every nonzero point; a strict certificate
has $\nabla V\cdot f_b<0$ there. No coefficient symmetry or SOS ansatz restricts the theorem.

Define

```math
\Phi(u)=16u^6-92u^5+125u^4-134u^3-103u^2-200u+100.
```

Let $u_*$ be the **unique real root greater than one** of $\Phi$, and set
$B=\sqrt{u_*}$. Exact isolating intervals and uniqueness are established in the
[dual certificate](docs/Dual.md). Numerically, for orientation only,

```math
u_*=4.52903746039757\ldots,\qquad B=2.1281535330886186\ldots.
```

**Theorem.** For every real $b\ge0$:

1. A positive definite homogeneous quartic with strict derivative exists
   if and only if $0\le b<B$.
2. A positive definite homogeneous quartic with weak derivative exists
   if and only if $0\le b\le B$.
3. At $b=B$, a real homogeneous quartic has nonpositive Lie derivative
   everywhere off the origin if and only if it is $kV_*$ for $k\ge0$,
   where $V_*$ is the explicit positive endpoint quartic. Every nonzero
   member is therefore positive definite. Its negative derivative is a
   cubic square with exactly three distinct real projective zero lines.

The feasibility statements for signed $b$ use $|b|$. A quarter-turn
conjugates $f_b$ and $f_{-b}$ and transports the endpoint cone to $b=-B$.

This quartic classification fixes damping one; time rescaling also changes
angular speed. The written [extensions](docs/Extensions.md) treat
degree-preserving contraction for every $a>0$, and the
[all-degree theorem](docs/AllDegreeClassification.md) classifies unrestricted
polynomial and local analytic feasibility. The exact quartic threshold
$B_2(a)$ for arbitrary damping remains undetermined.

## 1. Angular reduction with the correct degree

For the larger family f_{a,b}=(-aR+b(x²−y²))(x,y)+R(-y,x), a>0,
write x=r cos θ, y=r sin θ. Direct expansion gives

```math
\dot r=r^3(-a+b\cos2\theta),\qquad \dot\theta=r^2.
```

For a real homogeneous polynomial V of degree 2N, N≥1, put
p(t)=V(cos(t/2),sin(t/2)). It is a real trigonometric polynomial of
Fourier degree at most N. With t=2θ,

```math
\mathcal L_{f_{a,b}}V
=2r^{2N+2}\{p'(t)+N(-a+b\cos t)p(t)\}.                 \qquad (1)
```

The prime denotes differentiation in t. The nonzero-point positivity
condition on V is equivalent to p>0. For quartics N=2, a=1, the negative
unit-circle derivative is

```math
q=4p-4b\cos(t)p-2p'.                                  \qquad (2)
```

## 2. One weak certificate gives strict certificates below it

**Contraction lemma.** Fix a>0, B₀>0 and N≥1. If a positive definite
homogeneous polynomial of degree 2N is a weak certificate at B₀, then for
each 0≤ρ<1 there is a positive definite homogeneous polynomial of the
same degree that is a strict certificate at b=ρB₀.

**Proof.** Strict Fejér–Riesz factorization, in the outer-factor form used
in Liu–Fitzsimmons Lemma III.2, gives

```math
p(t)=|Q(e^{it})|^2,\qquad \deg Q\le N,
```

where Q has no zero in the closed unit disk. Set

```math
p_\rho(t)=|Q(\rho e^{it})|^2,\qquad
 g(t)=\frac1N\frac{p'(t)}{p(t)},\qquad
 w(t)=a-B_0\cos t-g(t)\ge0.
```

The mean of g is zero, so the mean of w is a>0. The function

```math
F(z)=a-B_0z-\frac{2i}{N}\frac{zQ'(z)}{Q(z)}
```

is holomorphic on a neighborhood of the closed unit disk. On its boundary,
Re F(e^{it})=w(t); at radius ρ,

```math
\operatorname{Re}F(\rho e^{it})
=a-\rho B_0\cos t-\frac1N\frac{p_\rho'(t)}{p_\rho(t)}.
```

Poisson's formula gives this last expression as the Poisson average of w.
For 0≤ρ<1 the Poisson kernel is everywhere at least (1−ρ)/(1+ρ), hence

```math
a-\rho B_0\cos t-\frac1N\frac{p_\rho'}{p_\rho}
\ge a\frac{1-\rho}{1+\rho}>0.                           \qquad (3)
```

The polynomial degree is preserved, not merely the smooth Lyapunov
condition. Pad Q(z)=Σ_{k=0}^N q_k z^k and define

```math
H_\rho(x,y)=\sum_{k=0}^Nq_k\rho^k(x+iy)^k(x-iy)^{N-k},
\qquad V_\rho(x,y)=|H_\rho(x,y)|^2.                    \qquad (4)
```

The real and imaginary parts of Hρ are real homogeneous polynomials of
degree N, so Vρ is a real homogeneous polynomial of degree 2N. On the
unit circle it equals pρ(2θ). It is positive away from the origin because
Q is zero-free on the closed disk. Equations (1) and (3) give the strict
derivative inequality. At ρ=0 it is |Q(0)|²R^N, so this endpoint is
included. ∎

The degree-four, damping-one specialization is formalized by real
polynomial factorization and the complex maximum principle; see the
[formal architecture](IMPLEMENTATION.md). The general-degree statement and
Poisson margin above remain written analytic results.

## 3. Exact endpoint witness and dual obstruction

The following two finite facts close the remaining problem.

- [endpoint certificate](docs/Endpoint.md) constructs real algebraic coefficients v_j and
  a monic cubic h(1,z). It proves the exact identity
  −∇V_*·f_B=h² and positive definiteness of a 3×3 Gram matrix for V_*.
  Thus V_* is an admissible **weak** quartic. The cubic has three distinct
  real roots, isolated in disjoint rational intervals.
- [dual certificate](docs/Dual.md) constructs a normalized linear functional ℓ on
  trigonometric polynomials of degree at most three. Its 4×4 Hermitian
  moment matrix is PSD of rank three, and ℓ(4p−4B cos(t)p−2p')=0 for
  **every** real trigonometric polynomial p of degree at most two.
  Positivity of ℓ on strictly positive trigonometric polynomials excludes
  a strictly negative quartic derivative at B. The endpoint note also
  gives a finite three-atom interpretation, avoiding a general SOS theorem
  for this particular obstruction.

These are exact identities and exact positivity bounds at the specified
algebraic root. The [exact replays](evidence/README.md)
regenerate the data; floating-point SDP or grid feasibility is not used
as proof.

## 4. Exhaustion of the parameter line

Apply the contraction lemma to V_* at B. It supplies strict quartics for
every 0≤b<B. At B, V_* supplies a weak certificate and the dual excludes
every strict certificate.

Suppose a weak quartic existed at b>B. Contract it with ρ=B/b∈(0,1).
The lemma would give a strict quartic at B, contradicting the exact dual
obstruction. Thus **no weak quartic** exists at any b>B. A strict quartic
is also weak, so this proves both iff statements, with no uncovered
interval or numerical inference.

For the endpoint cone, take any real homogeneous quartic $V$ with
$-\nabla V\cdot f_B\ge0$, without assuming a sign for $V$. The
[positive three-atom functional](docs/Endpoint.md#an-elementary-positive-dual-functional)
annihilates its derivative, so that derivative vanishes on all three
projective support lines. Nonnegativity forces at least a double root at
each line, exhausting degree six. Hence $-\nabla V\cdot f_B=kh^2$ for
$k\ge0$. The $7\times5$ derivative coefficient map has rank five, so the
identity $-\nabla V_*\cdot f_B=h^2$ gives $V=kV_*$. Conversely, every such
nonnegative multiple has nonpositive derivative. If $V\ne0$, then $k>0$
and $V$ is positive definite, with the same three derivative-zero lines.

## Degree separation and analytic extensions

The [integer quartic at $b=2$](docs/Applications.md) is strict where no
positive weak quadratic exists. The [integer sextic at $b=9/4$](docs/SexticSeparation.md)
is strict where neither a positive weak quadratic nor a positive weak quartic
exists. Both pointwise degree separations are formalized.

The written [quadratic boundary](docs/QuadraticBoundary.md) treats all
positive damping. The written [all-degree theorem](docs/AllDegreeClassification.md)
proves that homogeneous polynomial certificates and local real-analytic
weak certificates exist exactly for $|b|<(1+a^{2/3})^{3/2}$, with strict
polynomials in every sufficiently large even degree. The
[quantitative bound](docs/QuantitativeDegreeBound.md) supplies an explicit
sufficient degree. These analytic results are outside the Lean contract.
