# Exact quadratic boundary for every positive damping

This is a written analytic theorem, outside the compared Lean contract.

## Theorem

Let

```math
f_{a,b}(x,y)=(-aR+b(x^2-y^2))(x,y)+R(-y,x),\qquad R=x^2+y^2,\quad a>0.
```

There is exactly one positive real number $c$ satisfying

```math
a^2=c^2(2c+1).
```

Put

```math
\alpha=\sqrt{2c+1},\quad \beta=\sqrt{2c},\qquad
B_1(a)=(c+1)\beta.
```

Then a positive definite real homogeneous quadratic with strictly negative
Lie derivative away from the origin exists **if and only if**
$|b|<B_1(a)$. A positive definite quadratic with weakly nonpositive
Lie derivative exists **if and only if** $|b|\le B_1(a)$.
At each endpoint the weak quadratic is unique up to a positive scalar.

The parameterization

```math
(a,B_1(a))=\big(c\sqrt{2c+1},(c+1)\sqrt{2c}\big),\qquad c>0,
```

is an exact complete description of the boundary curve. At damping one,

```math
B_1(1)=1.9001890993467045\ldots,
```

and $B_1(1)^2$ is the unique positive root of

```math
4u^3-11u^2-8u-16=0.
```

Consequently the [quartic theorem](../Proof.md) gives the entire strict degree
separation interval $[B_1(1),B_2(1))$: throughout its interior no weak
quadratic exists and a strict quartic does exist. At $b=B_1(1)$ a weak
quadratic exists but no strict quadratic does, while a strict quartic exists.

## 1. Existence and the endpoint certificate

The function $c\mapsto c\sqrt{2c+1}$ is strictly increasing from zero
to infinity on $(0,\infty)$, so it uniquely determines $c$ for each
positive $a$. In particular $a=c\alpha$.

Define

```math
\begin{aligned}
U_*(x,y)&=\big((c+1)\alpha-c\beta\big)x^2
 -2\alpha\beta xy
 +\big((c+1)\alpha+c\beta\big)y^2,\\
h(x,y)&=(\alpha-\beta)x^2+2xy-(\alpha+\beta)y^2.
\end{aligned}
```

The symmetric matrix of $U_*$ has positive upper-left entry and determinant

```math
\alpha^2(c+1)^2-c^2\beta^2-\alpha^2\beta^2=(c+1)^2>0.
```

The upper-left entry is positive because $\alpha>\beta>0$.
Thus $U_*$ is positive definite. Direct polynomial expansion gives

```math
\boxed{-\mathcal L_{f_{a,B_1(a)}}U_*=2c(c+1)h^2.}
\qquad (1)
```

Only $\alpha^2=2c+1$, $\beta^2=2c$,
$a=c\alpha$, and $B_1(a)=(c+1)\beta$ are used in this identity.
It supplies a weak certificate at the proposed boundary.

The quadratic $h(1,z)$ has two distinct real roots,

```math
z_\pm=\frac{1\pm\sqrt2}{\alpha+\beta}.
\qquad (2)
```

Hence the endpoint derivative vanishes precisely on two distinct real
projective lines.

## 2. A two-point positive dual obstruction

A homogeneous quadratic has unit-circle trace

```math
p(t)=u+v\cos t+w\sin t,\qquad t=2\theta,
```

and its negative Lie derivative on the unit circle is

```math
2q(t),\qquad q=-p'+(a-B_1(a)\cos t)p.
\qquad (3)
```

Choose $\phi,\psi\in(0,\pi/2)$ by

```math
\cos\phi=\frac{\alpha}{\sqrt{2(c+1)}},\quad
\sin\phi=\frac1{\sqrt{2(c+1)}},\qquad
\cos\psi=\sqrt{\frac c{c+1}},\quad
\sin\psi=\frac1{\sqrt{c+1}}.
```

Let $t_\pm=\phi\pm\psi$ and define the positive functional

```math
\ell(g)=\frac{g(t_+)+g(t_-)}2.
```

Its first two complex moments are

```math
\begin{aligned}
m_0&=1,\\
m_1=\ell(e^{it})&=\frac{a+ic}{B_1(a)},\\
m_2=\ell(e^{2it})&=
\frac{c-1}{(c+1)^2}(c+i\alpha)
 =\frac{2(a-i)}{B_1(a)}m_1-1.
\end{aligned}
\qquad (4)
```

The corresponding identities for negative frequencies follow by complex
conjugation. Thus for $j=-1,0,1$,

```math
(a-ij)m_j-\frac{B_1(a)}2(m_{j-1}+m_{j+1})=0.
```

Applying this identity to the three Fourier coefficients of any $p$ in
(3) proves $\ell(q)=0$. A strictly positive $q$ would have
$\ell(q)>0$, a contradiction. Therefore no quadratic, regardless of its
own sign, can have strictly negative Lie derivative at the boundary.
This is an elementary positive two-atom certificate; no semidefinite solver
or general moment representation theorem is required.

The support points satisfy
$\alpha\cos t_\pm+\sin t_\pm=\beta$, so they correspond to the
zero lines (2) of $h$.

## 3. Exhaustion of the parameter line

Apply the [degree-preserving contraction lemma](../Proof.md#2-one-weak-certificate-gives-strict-certificates-below-it) with
$N=1$ to (1). It supplies strict quadratics for every
$0\le b<B_1(a)$. If a weak quadratic existed at some $b>B_1(a)$,
contracting it to the parameter $B_1(a)$ would produce a strict quadratic
there, contradicting the two-point obstruction. This proves both interval
classifications for nonnegative $b$.

A quarter-turn conjugates the fields with parameters $b$ and $-b$,
proving the signed version.

For a completely explicit interior construction, write $b=\rho B_1(a)$,
$0\le\rho<1$, and set

```math
\begin{aligned}
K_\rho&=\frac{c+1}{2}\big((\alpha+1)+(\alpha-1)\rho^2\big),\\
U_\rho(x,y)&=K_\rho R
 -\rho\beta\big(c(x^2-y^2)+2\alpha xy\big).
\end{aligned}
\qquad (5)
```

This is precisely the outer-factor contraction of $U_*$.
Indeed its endpoint trace has constant coefficient $\alpha(c+1)$
and oscillation amplitude $\beta(c+1)$. The squared magnitudes of its two
spectral coefficients are $(c+1)(\alpha+1)/2$ and
$(c+1)(\alpha-1)/2$. Their sum is the constant coefficient, twice their
geometric mean is the oscillation amplitude, and their difference is
$c+1$. Contracting the coefficient of $e^{it}$
by $\rho$ gives (5). The contraction lemma proves that $U_\rho$
is positive definite and has strictly negative Lie derivative. It also gives

```math
-\mathcal L_{f_{a,b}}U_\rho(z)
\ge 2a\frac{1-\rho}{1+\rho}\,\|z\|^2 U_\rho(z),\qquad z\ne0.
```

At $\rho=0$, (5) is a positive multiple of $R$.

## 4. Endpoint uniqueness

Let $U$ be a weak positive definite quadratic at the endpoint, and let
$D=-\mathcal L_f U$. The dual identity and positivity force $D$ to
vanish on both lines (2). A nonnegative binary quartic has even root
multiplicity on each real projective zero line. The two lines therefore
exhaust degree four, and $D=k h^2$ for some $k\ge0$.

The quadratic Lie-derivative map is injective at $a>0$, $b=B_1(a)>0$.
For example, if (3) vanishes identically, its second-harmonic coefficients
are $-bv/2$ and $-bw/2$; thus $v=w=0$. Its constant coefficient is
then $au$, forcing $u=0$. Equation (1) now implies
$U=kU_*/[2c(c+1)]$. Positive definiteness forces $k>0$.

## 5. An algebraic equation for arbitrary damping

Eliminating $c$ gives the necessary identity for $u=B_1(a)^2$:

```math
4u^3+(1-12a^2)u^2+(12a^4-20a^2)u-4a^2(a^2+1)^2=0.
\qquad (6)
```

The positive $c$-parameterization, rather than an unspecified root of (6),
is the definition of the boundary. At $a=1$, Descartes' rule of signs
shows that $4u^3-11u^2-8u-16$ has exactly one positive root.

## Exact replay

Run `python evidence/verify_quadratic_boundary.py` from the repository root
to check the endpoint identity, determinant, moment recurrence and elimination
identity by exact symbolic polynomial arithmetic. The classical contraction
lemma is proved in the [main proof](../Proof.md#2-one-weak-certificate-gives-strict-certificates-below-it).
