# Exact all-degree and local analytic classification

## Theorem

This is a written analytic theorem, outside the compared Lean contract.

For

```math
R=x^2+y^2,\qquad
f_{a,b}=(-aR+b(x^2-y^2))(x,y)+R(-y,x),\quad a>0,
```

define

```math
C(a)=\bigl(1+a^{2/3}\bigr)^{3/2}.
```

**Theorem.** The following conditions are equivalent:

1. `|b| < C(a)`.
2. Some positive definite homogeneous polynomial of positive degree has
   strictly negative Lie derivative off the origin.
3. Some positive definite homogeneous polynomial of positive degree has
   nonpositive Lie derivative off the origin.
4. A local real-analytic weak Lyapunov function exists: there are an open
   neighborhood `U` of the origin, a real-analytic function `V` on `U`, and
   `epsilon > 0` such that `V(0)=0`, `V(z)>0`, and `L_f V(z)<=0` for
   `0 < ||z|| < epsilon`.

Throughout, positive definiteness includes `V(0)=0`; constant positive
polynomials are not Lyapunov certificates here. The homogeneous certificates
in conditions 2–3 have positive degree explicitly.

The endpoint is excluded in every finite degree, including under the weak
derivative convention. For the attained fixed-degree thresholds `B_N(a)`
defined in the [fixed-degree theorem](Extensions.md),

```math
B_N(a)<C(a)\quad(N\ge1),\qquad \lim_{N\to\infty}B_N(a)=C(a).
```

In fact, every fixed `|b|<C(a)` admits a strict certificate in every
sufficiently large even degree. This convergence statement does not claim
that `B_N(a)` is monotone in `N`.

The family and its GAS result are due to Liu–Fitzsimmons
[arXiv:2607.16171v1](https://arxiv.org/abs/2607.16171v1), Section IV.D.
Their sufficient all-degree obstruction is `|b| >= 2(a+1)`. The present
argument supplies the exact boundary by combining an analytic obstruction
with a positive-functional existence argument. The classical ingredients
are strict scalar Fejer–Riesz factorization, Schwarz's lemma,
norm-preserving real Hahn–Banach, the Riesz representation theorem on a
compact space, and finite atomic approximation of probability measures.

## 1. Angular coordinates and an automatic positivity lemma

The field has polar equations

```math
\dot r=r^3(-a+b\cos2\theta),\qquad \dot\theta=r^2.
```

For a homogeneous polynomial `V` of degree `2N`, put

```math
p(t)=V(\cos(t/2),\sin(t/2)).
```

Then `p` is a real trigonometric polynomial of degree at most `N`, and

```math
\mathcal L_fV
=2r^{2N+2}\bigl[p'(t)+N(-a+b\cos t)p(t)\bigr].                 \qquad (1)
```

We will also use the following fact for an arbitrary positive integer
degree `m`, without first assuming positivity of the polynomial.

**Lemma 1 (automatic positivity and injectivity).** Let `V` be a real
homogeneous polynomial of positive degree `m`. If `L_f V <= 0` everywhere
off the origin, then `V >= 0`. If `V` is nonzero, then it is positive
definite, and consequently `m` is even. If `L_f V` vanishes identically,
then `V=0`.

**Proof.** Set `v(theta)=V(cos(theta),sin(theta))`. The Lie inequality is

```math
v'(\theta)+m(-a+b\cos2\theta)v(\theta)\le0.
```

For a fixed basepoint `theta_0`, the integrating factor

```math
E(\theta)=\exp\!\left(m\left[-a(\theta-\theta_0)
+\frac b2(\sin2\theta-\sin2\theta_0)\right]\right)v(\theta)
```

is nonincreasing. Periodicity gives

```math
e^{-2\pi ma}v(\theta_0)\le v(\theta_0).
```

Since `0 < exp(-2*pi*m*a) < 1`, it follows that `v(theta_0)>=0`.
The basepoint was arbitrary. If `v(theta_0)=0`, monotonicity and
nonnegativity imply `E=0` throughout the next full period, so `v` and
then `V` vanish identically. Thus a nonzero `V` is positive off the
origin. Odd degree would give `V(-z)=-V(z)`, so the degree must be even.
Finally, if the Lie derivative is identically zero, the integrating
factor is constant. The full-period identity forces `v(theta_0)=0` at
every basepoint. QED.

## 2. Spectral factors and two positive moment sequences

Suppose a positive definite homogeneous polynomial of degree `2N` is a
weak certificate. Strict scalar Fejer–Riesz factorization gives

```math
p(t)=|Q(e^{it})|^2,\qquad
Q(z)=q_0\prod_{j=1}^{L}(1-\alpha_jz),\qquad |\alpha_j|<1,
\quad L\le N.
```

Pad the list by `N-L` zeros and define

```math
P(z)=\frac1N\sum_{j=1}^{N}\frac{1+\alpha_jz}{1-\alpha_jz},
\qquad
F(z)=a-i-bz+iP(z).                                           \qquad (2)
```

Each function is holomorphic on a neighborhood of the closed disk.
Moreover `P(0)=1` and `F(0)=a`. On the unit circle,

```math
\operatorname{Re}P(z)>0,\qquad
\operatorname{Re}F(e^{it})
=a-b\cos t-\frac1N\frac{p'(t)}{p(t)}\ge0.                  \qquad (3)
```

Indeed, the real part of each summand in `P` is
`(1-|alpha_j|^2)/|1-alpha_j*z|^2`, and direct logarithmic
differentiation identifies `Im P` with `p'/(Np)`.

Use normalized Lebesgue measure `dt/(2*pi)` on the circle and densities

```math
M(t)=\operatorname{Re}P(e^{-it}),\qquad
K(t)=\operatorname{Re}F(e^{-it}).
```

These define positive measures `mu,nu` with respective masses `1,a`.
The reversed angle fixes the moment convention

```math
\mu_k=\int e^{ikt}\,d\mu(t),\qquad
\nu_k=\int e^{ikt}\,d\nu(t).
```

Expanding (2) gives

```math
\nu_k=i\mu_k-\frac b2\,\mathbf1_{k=1}\quad(k\ge1).          \qquad (4)
```

The density `M` is continuous and strictly positive; let

```math
m_0=\min_t M(t)>0.                                         \qquad (5)
```

This strict lower bound, which depends on the individual finite-degree
certificate, will exclude equality at the all-degree boundary.

## 3. Necessity: the quadrant-map bound is strict

Fix arbitrary `u,v>0`, and abbreviate `s=sqrt(u^2+v^2)`. Define

```math
\gamma=\frac{u-iv}{s},\qquad
q(z)=v^2-u^2+2iuv\frac{1+\gamma z}{1-\gamma z},\qquad
h(z)=\sqrt{q(z)},                                         \qquad (6)
```

where the square root is the branch on the upper half-plane taking
values in the open first quadrant. Since `|gamma|=1`, the Mobius factor
in (6) has positive real part on the open unit disk. Thus `q` takes
values in the upper half-plane and `h` is holomorphic with
`Re h>0` and `Im h>0`. Its first two Taylor coefficients are

```math
h(0)=v+iu,\qquad h'(0)=\frac{2uv}{s}>0.                    \qquad (7)
```

For `0 <= rho < 1`, put `h_rho(z)=h(rho*z)`. It is holomorphic on a
neighborhood of the closed unit disk, so its Taylor series there
converges uniformly. Apply (4) termwise to this series. Its real and
imaginary parts give the exact identity

```math
\int\operatorname{Im}h_\rho(e^{it})\,d\mu(t)
+\int\operatorname{Re}h_\rho(e^{it})\,d\nu(t)
=u+av-\rho\,\frac{buv}{s}.                                \qquad (8)
```

For clarity, the cancellation for each coefficient `h_k` is

```math
\operatorname{Im}(h_k\mu_k)+\operatorname{Re}(h_k\nu_k)
=-\frac b2\mathbf1_{k=1}\operatorname{Re}h_k.
```

Both integrands on the left of (8) are nonnegative. The harmonic mean
value property says that the normalized Lebesgue mean of
`Im h_rho` is `u`. By (5), the first integral is therefore at least
`m_0*u`. Consequently, for every `rho<1`,

```math
u+av-\rho\frac{buv}{s}\ge m_0u>0.
```

Letting `rho` increase to one gives

```math
b<\frac{(u+av)\sqrt{u^2+v^2}}{uv}.                       \qquad (9)
```

No boundary-integrability assertion about the singular map (6) is
needed; only the scalar right side is passed to the limit.

With `t=u/v`, the right side of (9) is

```math
J(t)=\frac{(t+a)\sqrt{1+t^2}}{t}.
```

Its derivative has the sign of `t^3-a`; its unique minimum occurs at
`t=a^(1/3)` and equals `C(a)`. Thus every weak positive homogeneous
polynomial certificate satisfies `b<C(a)`.

A quarter-turn of the plane conjugates `f_{a,b}` to `f_{a,-b}`.
Applying the same argument after this transformation proves the necessary
condition `|b|<C(a)` for arbitrary signed `b`.

## 4. Sufficiency: positive extension supplies the moments

We first solve a relaxed positive-measure problem at any

```math
0\le b_0\le C(a).                                         \qquad (10)
```

Let `T` be the unit circle and let

```math
E=C(T,\mathbb R)\oplus_\infty C(T,\mathbb R).
```

Its norm is the larger of the two sup norms, its order is coordinatewise,
and its order unit is `e=(1,1)`. Let the real linear subspace `S` consist
of pairs `(Im h, Re h)` on the circle, where `h` is any complex analytic
polynomial. The assignment from `h` to this pair is injective. Write
`h(0)=v+iu` and `h_1=h'(0)`, and define

```math
\Lambda(\operatorname{Im}h,\operatorname{Re}h)
=u+av-\frac{b_0}{2}\operatorname{Re}h_1.                   \qquad (11)
```

This is a well-defined real linear functional on `S`.

**Claim: `Lambda` is positive on `S`.** Suppose `Re h>=0` and
`Im h>=0` on the circle. The harmonic minimum principle gives the
same inequalities in the disk. If `u=0` or `v=0`, the corresponding
nonnegative harmonic function vanishes at the center and hence identically;
the holomorphic `h` is constant, and (11) is nonnegative.

If `u,v>0`, then `h^2` maps the disk to the upper half-plane. The
upper-half-plane form of Schwarz's lemma at the origin gives

```math
|(h^2)'(0)|\le2\operatorname{Im}(h(0)^2)=4uv.
```

Hence

```math
|h_1|\le\frac{2uv}{\sqrt{u^2+v^2}}.
```

Combining this with (10) and the minimum calculation following (9),

```math
\Lambda\ge u+av-\frac{b_0uv}{\sqrt{u^2+v^2}}\ge0.
```

This proves the claim.

The subspace `S` contains `e`, obtained from `h=1+i`, and
`Lambda(e)=1+a`. For any `s` in `S`, order-unit bounds and positivity
give `|Lambda(s)| <= (1+a)||s||`. Equality on `e` shows

```math
\|\Lambda\|=1+a.
```

Real Hahn–Banach extends `Lambda` to a functional `Lambda_tilde` on
all of `E` with the same norm. It still has
`Lambda_tilde(e)=1+a`. This extension is positive: if `0<=f<=e`, then
`||e-f||<=1`, so

```math
\widetilde\Lambda(f)
=1+a-\widetilde\Lambda(e-f)\ge0.
```

Scaling proves positivity on every nonnegative `f` in `E`.

Restrict the extended functional to each coordinate. The Riesz
representation theorem supplies finite positive Borel measures `mu,nu`
on `T` such that

```math
\widetilde\Lambda(A,B)=\int A\,d\mu+\int B\,d\nu.
```

Using the constant polynomials `i` and `1`, respectively, yields

```math
\mu(T)=1,\qquad\nu(T)=a.
```

Testing (11) on `h(z)=z^k` and `h(z)=iz^k`, `k>=1`, gives

```math
\operatorname{Im}\mu_k+\operatorname{Re}\nu_k
=-\frac{b_0}{2}\mathbf1_{k=1},\qquad
\operatorname{Re}\mu_k-\operatorname{Im}\nu_k=0.
```

Therefore these measures solve the exact moment relations

```math
\nu_k=i\mu_k-\frac{b_0}{2}\mathbf1_{k=1}\quad(k\ge1).       \qquad (12)
```

## 5. Smoothing and finite equal weights produce a polynomial

Now fix `0 < b < C(a)`, choose `b < b_0 <= C(a)`, and let
`rho=b/b_0` in `(0,1)`. Take measures from Section 4. Define

```math
P_\rho(z)=\int_T\frac{1+\rho\xi z}{1-\rho\xi z}\,d\mu(\xi),
\qquad
F_\rho(z)=\int_T\frac{1+\rho\xi z}{1-\rho\xi z}\,d\nu(\xi).
```

Both functions are holomorphic on `|z|<1/rho`, and (12) gives

```math
F_\rho(z)=a-i-bz+iP_\rho(z).                               \qquad (13)
```

For `|z|<=1`, the real part of each kernel is at least
`(1-rho)/(1+rho)`. Thus

```math
\operatorname{Re}F_\rho(z)
\ge\delta:=a\frac{1-\rho}{1+\rho}>0.                      \qquad (14)
```

The kernel is jointly continuous on `T` times the closed unit disk.
Partition `T` into finitely many sufficiently small pieces and replace
the mass on each piece by a point mass at a representative. Uniform
continuity makes the resulting kernel integral uniformly close to
`P_rho`. Approximate the finitely many nonnegative weights by rational
weights that sum to one. This preserves uniform closeness. A common
denominator turns the rationally weighted measure into an equally
weighted empirical measure, with repetitions permitted.

Consequently, there are `N>=1` and circle points `xi_1,...,xi_N` such
that, with `alpha_j=rho*xi_j`,

```math
P_N(z)=\frac1N\sum_{j=1}^{N}\frac{1+\alpha_jz}{1-\alpha_jz},
\qquad
\sup_{|z|\le1}|P_N(z)-P_\rho(z)|<\frac\delta2.
```

Let `F_N(z)=a-i-bz+iP_N(z)`. Equations (13)–(14) imply

```math
\operatorname{Re}F_N(z)>\frac\delta2\quad(|z|\le1).        \qquad (15)
```

Define

```math
Q_N(z)=\prod_{j=1}^{N}(1-\alpha_jz)
=\sum_{k=0}^{N}q_kz^k,
```

and homogenize it as

```math
H_N(x,y)=\sum_{k=0}^{N}q_k(x+iy)^k(x-iy)^{N-k},
\qquad
V_N(x,y)=|H_N(x,y)|^2.                                    \qquad (16)
```

The real and imaginary parts of `H_N` are real homogeneous polynomials
of degree `N`, so `V_N` is a real homogeneous polynomial of degree
`2N`. For `x=r cos(theta)`, `y=r sin(theta)`,

```math
V_N(x,y)=r^{2N}|Q_N(e^{2i\theta})|^2>0\quad(r>0),
```

because all `|alpha_j|=rho<1`. The same logarithmic-derivative identity
as in Section 2 gives

```math
a-b\cos t-\frac1N\frac{p_N'(t)}{p_N(t)}
=\operatorname{Re}F_N(e^{it})>0.
```

Equation (1) now proves `L_f V_N < 0` off the origin.

For `b=0`, the radial quadratic `R` already satisfies
`L_f R=-2aR^2<0`. Negative `b` is handled by the quarter-turn conjugacy.
This proves sufficiency for every `|b|<C(a)`.

The construction is an existence proof. It neither gives a minimal
degree nor identifies the representing measures explicitly. The finite
equal weights are essential: they produce an actual finite product with
integer multiplicities, and hence an ordinary polynomial rather than
a fractional power or a general smooth angular function.

**Every sufficiently large even degree.** The approximation can be made
for every sufficiently large denominator `N`. Fix the fine partition
already used above, with `J` pieces and masses `w_1,...,w_J`. For each
`N`, choose nonnegative integers `n_j` summing to `N` by rounding the
weights `N*w_j`; one may take floors and distribute the remaining units.
Then `sum_j |n_j/N-w_j| <= J/N`. Since the kernel is uniformly bounded
on the compact domain, the extra approximation error tends to zero as
`N` increases. The partition error is fixed below a sufficiently small
part of the margin. Thus (15) holds for every sufficiently large `N`,
and (16) gives degree `2N` in each case. At `b=0`, use `R^N` directly.

## 6. Local analytic obstruction and fixed-degree consequences

Suppose a local real-analytic weak Lyapunov function `V` exists. Since
`V(0)=0` and `V` is strictly positive on a punctured ball, it is not
identically zero. Its convergent Taylor expansion has a lowest nonzero
homogeneous term `P_m`, with `m>=1`.

For each fixed `z`, as `r` decreases to zero,

```math
\frac{V(rz)}{r^m}\longrightarrow P_m(z),\qquad
\frac{\mathcal L_fV(rz)}{r^{m+2}}
\longrightarrow\mathcal L_fP_m(z).                        \qquad (17)
```

The second limit follows by differentiating the analytic expansion:
the derivative remainder is `O(r^m)`, while the cubic field contributes
`r^3`. The local weak inequalities imply `L_f P_m<=0` everywhere.
Lemma 1 makes `P_m` positive definite and its degree even. Section 3
then forces `|b|<C(a)`. Conversely, the strict global polynomial supplied
by Sections 4–5 is a local real-analytic weak certificate. This proves
the fourth equivalence in the theorem, including the equality case.

For a fixed `N`, the [compactness and integrating-factor argument](Extensions.md#every-fixed-degree-has-one-attained-boundary)
gives weak endpoint attainment at `B_N(a)`. Section 3 therefore
implies `B_N(a)<C(a)`. Sections 4–5 give a certificate in some finite
degree for every parameter below `C(a)`, and so
`sup_N B_N(a)=C(a)`.

More strongly, fix any `0<=b<C(a)`. The last paragraph of Section 5
implies `b<B_N(a)` for every sufficiently large `N`. Since each
`B_N(a)<C(a)`, this proves the full limit `B_N(a)->C(a)`.

As a further consequence, certificate degrees must become unbounded
as `b` approaches `C(a)` from below. For any finite degree cap, there
are only finitely many attained thresholds under that cap, and their
maximum is strictly smaller than `C(a)`.

## 7. Damping one and a smaller integer counterexample

At `a=1`, the theorem gives

```math
C(1)=2\sqrt2\approx2.828427124746190.
```

Combined with the repository's quartic classification, the parameter
interval `B < |b| < 2*sqrt(2)` admits some strict polynomial certificate
but no weak quartic certificate. The [sextic certificate](SexticSeparation.md)
gives minimum degree six for `B < |b| <= 9/4`; minimum degrees throughout
the remaining interval are not determined here.

The integer parameter `b=3` is beyond the all-degree cutoff. Its
field is

```math
\dot x=2x^3-x^2y-4xy^2-y^3,\qquad
\dot y=x^3+2x^2y+xy^2-4y^3.
```

This field is globally asymptotically stable, as its
[rational certificate](IntegerCounterexample.md) proves, while the theorem
rules out every local real-analytic weak Lyapunov function. Its cubic integer
coefficients have maximum absolute value four; no coefficient-minimality
claim among all such fields is made.

## Integer coefficients and quantitative degree

For each fixed parameter pair in the strict region, the certificate can be
chosen with integer coefficients. A strict homogeneous polynomial and its
negative Lie derivative have positive minima on the unit circle. Sufficiently
small rational perturbations of its finitely many coefficients preserve both
minima; multiplication by a common positive denominator gives integer
coefficients in the same degree. This gives no bound on their size.

The [quantitative degree bound](QuantitativeDegreeBound.md) approximates the
boundary measure with midpoint quantiles to give an explicit sufficient
degree and a rate of convergence of the fixed-degree thresholds.

## Smooth certificates beyond the analytic boundary

If $|b|\ge C(a)$, every smooth local weak Lyapunov function must be flat
at the origin. Otherwise its first nonzero Taylor term and the Taylor
expansion of its gradient give the same leading homogeneous Lie inequality
as (17); Lemma 1 would produce an excluded positive homogeneous polynomial.
A smooth function may have all Taylor coefficients zero without vanishing
locally. Liu–Fitzsimmons supply a flat construction from a positive
homogeneous nonpolynomial certificate.

## References

- Liu–Fitzsimmons, [arXiv:2607.16171v1](https://arxiv.org/abs/2607.16171v1):
  strict outer factorization, the original Fourier obstruction, the local
  Taylor-term reduction, and the two-parameter family.
- The [quartic proof](../Proof.md#2-one-weak-certificate-gives-strict-certificates-below-it)
  gives the fixed-degree contraction; [Extensions](Extensions.md) proves
  fixed-degree endpoint attainment.
