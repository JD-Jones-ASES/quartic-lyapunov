# Exact dual obstruction at the quartic endpoint

Date: 2026-10-11. This note proves a finite algebraic obstruction for the
normalized family in the companion proof. It does not make a formal Lean
verification claim.

Let

```math
f_b(x,y)=(-r^2+b(x^2-y^2))(x,y)+r^2(-y,x),\qquad r^2=x^2+y^2.
```

A real homogeneous quartic restricts to a real trigonometric polynomial
$p(t)$ of degree at most two under $x=\cos\theta$,
$y=\sin\theta$, $t=2\theta$. Its negative orbital derivative on the
unit circle is

```math
q(t)=4p(t)-4b\cos(t)p(t)-2p'(t).
\qquad (1)
```

The prime in (1) means differentiation with respect to $t$, not
$\theta$. A strict polynomial derivative inequality requires
$q(t)>0$ for every real $t$.

## Algebraic endpoint and a rational auxiliary parameter

Define

```math
P(u)=16u^6-92u^5+125u^4-134u^3-103u^2-200u+100.
```

There is exactly one root $u>1$. Indeed,

```math
P(1+v)=16v^6+4v^5-95v^4-234v^3-435v^2-672v-288
```

has exactly one coefficient sign change, and

```math
P(9/2)=-11909/16<0,\qquad
P(23/5)=31695444/15625>0.
```

Thus this root lies in $(9/2,23/5)$. Write

```math
B=\sqrt u,
\quad N=24u^4-32u^3-2u^2+120u-50,
\quad D=16u^4-32u^3+93u^2-65u,
\quad c=N/D.
\qquad (2)
```

Numerically, only for orientation,
$u\approx4.52903746039757$, $B\approx2.12815353308862$,
and $c\approx1.410468547$. The proof uses the polynomial and rational
intervals, not these decimal approximations.

The following elementary bounds will be sufficient:

```math
D>0,\qquad \frac75<c<\frac{10}{7}.
\qquad (3)
```

To verify them put $v=u-9/2$, so $0<v<1/10$. Direct expansion gives

```math
\begin{aligned}
D&=16v^4+256v^3+1605v^2+4660v+20943/4,\\
5N-7D&=8v^4+208v^3+1175v^2+1910v+899/4,\\
10D-7N&=-8v^4-240v^3-1324v^2-1742v+1465/2.
\end{aligned}
```

The first two are positive term by term. The third is at least its value
at $v=1/10$, namely $340512/625>0$.

## The normalized moment functional

At $b=B$, define complex numbers

```math
m_0=1,\qquad m_1=(1+ic)/B,\qquad
m_2=\frac{2-i}{B}m_1-1,\qquad
m_3=\frac{2-2i}{B}m_2-m_1,
\quad m_{-j}=\overline{m_j}.
\qquad (4)
```

Let $\ell$ be the real functional on trigonometric polynomials of degree
at most three defined complex linearly by
$\ell(e^{ijt})=m_j$. Its Hermitian Toeplitz matrix is

```math
T=(m_{j-i})_{0\le i,j\le3}.
\qquad (5)
```

In particular, for $H(z)=\sum_{j=0}^3 h_jz^j$,
$\ell(|H(e^{it})|^2)=\overline h^{\mathsf T}Th$.
This specifies the convention and fixes all imaginary signs.

For $-2\le j\le2$, the moment recurrence is

```math
(4-2ij)m_j-2B(m_{j-1}+m_{j+1})=0.
\qquad (6)
```

For $j=1,2$, this is (4); for negative $j$, it is its conjugate;
for $j=0$, it follows from $\operatorname{Re}m_1=1/B$.
Applying (6) to each Fourier coefficient of $p$ proves

```math
\ell(4p-4B\cos(t)p-2p')=0
\qquad (7)
```

for **every** real trigonometric polynomial $p$ of degree at most two,
without any positivity assumption on $p$.

## Exact positive semidefiniteness and rank

The leading principal minors of $T$ are

```math
\Delta_1=1,\qquad
\Delta_2=\frac{u-1-c^2}{u},\qquad
\Delta_3=\frac{2uc-2c^3-c^2-2c-1}{u^2},\qquad
\Delta_4=\frac{F(u,c)}{u^4},
\qquad (8)
```

where

```math
\begin{aligned}
F(u,c)={}&(5-4u)c^4-8uc^3+(8u^2-20u+10)c^2\\
&+(8u^2-8u)c-4u^3+12u^2-16u+5.
\end{aligned}
\qquad (9)
```

The bounds (3) give

```math
u-1-c^2>\frac92-1-\frac{100}{49}=\frac{143}{98}>0,
```

and

```math
2uc-2c^3-c^2-2c-1
>2\frac92\frac75-2\left(\frac{10}{7}\right)^3
-\left(\frac{10}{7}\right)^2-2\frac{10}{7}-1
=\frac{1494}{1715}>0.
```

Finally, $F(u,N/D)=0$ is an exact polynomial identity modulo $P(u)=0$.
One convenient finite form to check, requiring only integer polynomial
arithmetic, is

```math
\begin{aligned}
0\equiv{}&(5-4u)N^4-8uN^3D+(8u^2-20u+10)N^2D^2\\
&+(8u^2-8u)ND^3+(-4u^3+12u^2-16u+5)D^4
\pmod{P(u)}.
\end{aligned}
\qquad (10)
```

Equations (8)--(10) prove $\Delta_1,\Delta_2,\Delta_3>0$ and
$\Delta_4=0$. The upper left $3\times3$ block is positive definite
by Sylvester's criterion. Its scalar Schur complement is zero, so $T$
is positive semidefinite of rank exactly three. Checking only these leading
minors is sufficient here because the first three are strictly positive
and the final Schur complement is zero; a generic claim that nonnegative
leading minors imply positive semidefiniteness would be false.

For provenance of the candidate, the last linear subresultant of
$F$ and $\partial F/\partial c$ is

```math
256u^2(4u-5)(Dc-N),
```

and their resultant is

```math
-4096u^4(4u-5)P(u).
```

These elimination identities explain the discovery of (2). The proof of
the obstruction uses (3)--(10) directly and does not assume that numerical
optimization or elimination alone certifies feasibility.

## Consequence for the strict derivative contract

By the Fejer--Riesz theorem, every nonnegative real trigonometric
polynomial $s$ of degree at most three has the form
$s(t)=|H(e^{it})|^2$ with $\deg H\le3$. Thus $T\succeq0$
implies $\ell(s)\ge0$. If $q(t)>0$ everywhere, compactness of the
circle gives $q\ge\varepsilon>0$; applying this observation to
$q-\varepsilon$ gives

```math
\ell(q)\ge\varepsilon\ell(1)=\varepsilon>0.
```

This contradicts (7). Therefore at $b=B$ no homogeneous quartic,
whether positive definite or otherwise, can have strictly negative orbital
derivative away from the origin.

This argument does **not** exclude a positive definite quartic with a weak
derivative inequality at $b=B$. Its negative derivative must lie in the
kernel face of this rank-three moment matrix. The companion endpoint
certificate establishes that this weak case actually occurs.

