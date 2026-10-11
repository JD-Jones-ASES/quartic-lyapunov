# An exact sextic certificate beyond the quartic boundary

The displayed strict sextic at $b=9/4$ and the absence of weak quadratics
and quartics there are formalized in
[SexticApplication.lean](../QuarticLyapunov/SexticApplication.lean); the
interval claims and minimum-degree tables below remain written supplements.

## The certificate at b = 9/4

For the original damping-one field, put

```math
\begin{aligned}
V_6(x,y)={}&34x^6-296x^5y+1247x^4y^2-2850x^3y^3\\
 &+3606x^2y^4-2358xy^5+634y^6.
\end{aligned}
```

Let $z=(x^3,x^2y,xy^2,y^3)^T$. Then

```math
V_6=z^TGz,\qquad
G=\begin{pmatrix}
34&-148&218&-99\\
-148&811&-1326&645\\
218&-1326&2316&-1179\\
-99&645&-1179&634
\end{pmatrix}.
```

The leading principal minors of $G$ are

```math
34,\quad 5670,\quad 372500,\quad 5858330.
```

They are all positive. Thus $G$ is positive definite, and $V_6$ is
strictly positive at every nonzero real pair.

Direct differentiation along the actual field with $b=9/4$ gives

```math
\begin{aligned}
D_8:=-\mathcal L_{f_{1,9/4}}V_6={}&41x^8-70x^7y-\frac{2647}{2}x^6y^2
 +3877x^5y^3\\
 &+\frac{15163}{2}x^4y^4-43918x^3y^5+66444x^2y^6\\
 &-42573xy^7+10005y^8.
\end{aligned}
```

For $w=(x^4,x^3y,x^2y^2,xy^3,y^4)^T$, an exact certificate is

```math
10D_8=w^THw,\qquad
H=\begin{pmatrix}
410&-350&-6768&13622&-6402\\
-350&301&5763&-11604&5453\\
-6768&5763&111827&-225043&105770\\
13622&-11604&-225043&452900&-212865\\
-6402&5453&105770&-212865&100050
\end{pmatrix}.
```

The leading principal minors of $H$ are

```math
410,\quad 910,\quad 9056,\quad 76594,\quad 31770.
```

All are strictly positive, so $D_8$ is strictly positive away from the
origin. This proves that $V_6$ is a strict homogeneous sextic Lyapunov
certificate at $b=9/4$.

## Quartic-versus-sextic separation

The [exact quartic threshold](../Proof.md) satisfies

```math
B_2(1)=2.1281535330886186\ldots<\frac94.
```

The upper inequality follows from the [rational isolating interval](Dual.md). Thus at $b=9/4$ there
is **no positive definite weak homogeneous quartic**, while the displayed
sextic is strict. A weak quadratic would square to a weak quartic, so none
exists either. Positive definite homogeneous polynomials considered here
vanish at the origin and have positive even degree, since an odd-degree
homogeneous polynomial changes sign under $z\mapsto-z$.
Therefore the smallest degree of either a weak or a strict homogeneous
polynomial certificate at this parameter is exactly six.

The [degree-preserving contraction lemma](../Proof.md#2-one-weak-certificate-gives-strict-certificates-below-it)
with $N=3$ extends strict sextic
feasibility to every $0\le b\le9/4$; the explicit certificate handles
$b=9/4$, and contraction handles smaller parameters. Quarter-turn
conjugacy supplies the same result for negative parameters. In particular,
throughout

```math
B_2(1)<|b|\le\frac94,
```

weak quartics are impossible and strict sextics exist. At $|b|=B_2(1)$,
a weak quartic exists but no strict quartic does, and a strict sextic exists.

Strictness persists for a small parameter perturbation, so the sextic
boundary satisfies $B_3(1)>9/4$. Its exact value is not determined here.

## The first three minimum-degree regimes

Combine this certificate with the [quadratic classification](QuadraticBoundary.md)
and the [quartic classification](../Proof.md). Write
$B_1=B_1(1)$ and $B_2=B_2(1)$. Their order is exact:
$B_1<2<B_2<9/4$. For the first inequality, the unique positive-root
polynomial $4u^3-11u^2-8u-16$ is positive at $u=4$; the other
inequalities follow from the quartic isolating interval. On the whole certified interval
$0\le|b|\le9/4$, the minimum strict certificate degree is exactly

| Parameter range | Minimum strict homogeneous degree |
| --- | ---: |
| $0\le\lvert b\rvert<B_1$ | 2 |
| $B_1\le\lvert b\rvert<B_2$ | 4 |
| $B_2\le\lvert b\rvert\le9/4$ | 6 |

Here certificates have positive degree and vanish at the origin; degree-zero
constants are excluded. For weak certificates the endpoints belong to the preceding degree:

| Parameter range | Minimum weak homogeneous degree |
| --- | ---: |
| $0\le\lvert b\rvert\le B_1$ | 2 |
| $B_1<\lvert b\rvert\le B_2$ | 4 |
| $B_2<\lvert b\rvert\le9/4$ | 6 |

These tables give the exact minimum degrees for $0\le|b|\le9/4$.
Minimum degrees above $9/4$ are not determined here; the
[all-degree theorem](AllDegreeClassification.md) classifies unrestricted-degree
existence exactly.

## Exact replay

Run `python evidence/verify_sextic_certificate.py`. The replay differentiates the
polynomial using exact rational coefficient arithmetic, checks both Gram
identities and every leading principal minor, and checks agreement with the
JSON certificate. It uses only Python's standard library and also runs under
`python -O`.
