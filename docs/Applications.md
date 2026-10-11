# Applications of the quartic analysis

These are exact mathematical consequences for the Liu–Fitzsimmons family
defined in [SOURCES](Sources.md). The contraction argument belongs with
the classification proof in [PROOF](../Proof.md). The rational identities
below were independently expanded in SymPy on 2026-10-11; no numerical
solver result is used as proof.

The [contraction lemma](../Proof.md#2-one-weak-certificate-gives-strict-certificates-below-it)
applies in every fixed even degree. [EXTENSIONS](Extensions.md) gives its
attained-boundary and quantitative consequences. Here the focus is an
explicit rational example where quartics improve on quadratics.

## Exact degree separation at b = 2

At \((a,b)=(1,2)\), set

\[
P=2x^4-9x^3y+20x^2y^2-20xy^3+8y^4.
\]

With \(v=(x^2,xy,y^2)^T\), one has \(P=v^TGv\), where

\[
G=\begin{pmatrix}
2&-9/2&3\\
-9/2&14&-10\\
3&-10&8
\end{pmatrix}.
\]

Its leading principal minors are \(2,31/4,6\), all positive.
Equivalently, an explicit identity is

\[
P=2\left(x^2-\frac94xy+\frac32y^2\right)^2
 +\frac{31}{8}\left(xy-\frac{26}{31}y^2\right)^2
 +\frac{24}{31}y^4.
\]

Direct differentiation gives

\[
\begin{aligned}
D:=-L_{f_{1,2}}P={}&x^6+4x^5y-14x^4y^2-52x^3y^3\\
 &+221x^2y^4-232xy^5+76y^6.
\end{aligned}
\]

For \(z=(x^3,x^2y,xy^2,y^3)^T\), one has \(D=z^THz\), where

\[
H=\begin{pmatrix}
1&2&-21/2&13/2\\
2&7&-65/2&21\\
-21/2&-65/2&179&-116\\
13/2&21&-116&76
\end{pmatrix}.
\]

Its leading principal minors are \(1,3,74,693/16\), all positive.
The corresponding explicit identity is

\[
\begin{aligned}
D={}&\left(x^3+2x^2y-\frac{21}{2}xy^2+\frac{13}{2}y^3\right)^2\\
 &+3\left(x^2y-\frac{23}{6}xy^2+\frac83y^3\right)^2\\
 &+\frac{74}{3}\left(xy^2-\frac{205}{296}y^3\right)^2
 +\frac{693}{1184}y^6.
\end{aligned}
\]

Both \(P\) and \(D\) are strictly positive off the origin: when
\(y\ne0\), the last term is positive; when \(y=0,x\ne0\), the
first term is positive. This proves a **strict quartic certificate**.
Its positive integer powers provide strict certificates of degree \(4k\)
for every \(k\ge1\) at this parameter.

### No positive definite weak quadratic

Write an arbitrary homogeneous quadratic as
\(U=Ax^2+Bxy+Cy^2\), and let \(D_U=-L_{f_{1,2}}U\).
Three exact evaluations are

\[
\begin{aligned}
D_U(4,-1)&=-552A-151B+110C,\\
D_U(3,2)&=210A-29B-132C,\\
D_U(1,1)&=8A+4B.
\end{aligned}
\]

They give the finite positive dual identity

\[
\boxed{24D_U(4,-1)+20D_U(3,2)+1051D_U(1,1)=-640A.}
\]

If \(U\) were positive definite, then \(A=U(1,0)>0\). If it had a
weak nonpositive Lie derivative, all three terms on the left would be
nonnegative, contradicting the negative right side. Thus **no positive
definite weak homogeneous quadratic exists**. This proof uses only
polynomial identities and real-order arithmetic.

The contraction principle also excludes weak homogeneous quadratics at
every \(b\ge2\) on the \(a=1\) slice: a witness above 2 would contract
to a strict quadratic at 2. This does not state the exact quadratic
feasibility threshold below 2.

### Independent trigonometric dual check

For comparison, let a real linear functional \(\ell\) on trigonometric
polynomials have moments

\[
m_0=1,\quad m_1=\frac12+\frac38i,\quad
m_2=-\frac18-\frac18i,\quad m_{-k}=\overline{m_k},
\qquad \ell(e^{ikt})=m_k.
\]

Its Hermitian Toeplitz matrix \(T=(m_{j-i})_{0\le i,j\le2}\) has
leading principal minors \(1,39/64,17/256\), so it is positive
definite. For every real trigonometric polynomial \(q\) of degree at
most one, direct calculation on the basis \(1,\cos t,\sin t\) gives

\[
\ell\bigl(-2q'+2(1-2\cos t)q\bigr)=0.
\]

Every nonzero nonnegative trigonometric polynomial of degree at most two
has strictly positive \(\ell\), by Fejér–Riesz factorization and
positive definiteness of \(T\). Thus a weak quadratic would force its
derivative expression to vanish identically. Writing
\(q=u+v\cos t+w\sin t\), its second-harmonic coefficients are
\(-2v\) and \(-2w\); their vanishing forces \(v=w=0\), after which
the constant coefficient \(2u\) forces \(u=0\). This contradicts
positive definiteness. This cross-check is not needed by the simpler
three-point algebraic proof above.

## Scope of this application

The result at \(b=2\) separates actual polynomial certificate degrees,
including weak quadratic versus strict quartic conditions. The quartic
and sextic are binary nonnegative forms with explicit SOS witnesses, so
this is **not** a nonnegative-versus-SOS gap. Global asymptotic stability
of the underlying family is already supplied by the source paper.
Current formal verification is recorded in [VERIFICATION.md](../VERIFICATION.md). Worldwide priority and human specialist review are not established.
