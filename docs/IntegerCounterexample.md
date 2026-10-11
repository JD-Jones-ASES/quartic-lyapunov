# An integer cubic field with a rational but no analytic certificate

This is a written consequence of the [all-degree classification](AllDegreeClassification.md),
outside the compared Lean contract.

## The field

At damping one and parameter three, the family becomes

```math
\boxed{\dot x=2x^3-x^2y-4xy^2-y^3,\qquad
\dot y=x^3+2x^2y+xy^2-4y^3.}
```

Since $3>2\sqrt2$, the all-degree theorem rules out every positive
definite homogeneous polynomial of positive degree with nonpositive Lie
derivative. The same theorem rules out every local real-analytic weak
Lyapunov function. Thus it also excludes nonhomogeneous polynomial
Lyapunov functions, even locally.

The coefficients are integers of absolute value at most four. On the
specific damping-one slice, three is the smallest positive integer
parameter for which all polynomial certificates fail: parameters one and
two have quadratic and quartic certificates, respectively.
This does not assert coefficient minimality among all possible fields.

## A rational certificate

Set

```math
R=x^2+y^2,\quad A=R-xy,\quad D=R+xy,
```

and define

```math
W(x,y)=R\left(\frac{A}{D}\right)^3\quad((x,y)\ne(0,0)),
\qquad W(0,0)=0.
```

Both $A$ and $D$ are positive off the origin, since
$|xy|\le R/2$. In particular,

```math
\frac{R}{27}\le W\le27R.
```

The function is smooth away from the origin and homogeneous of degree two.
Its angular profile is smooth with bounded derivatives. Therefore
$W=O(\|z\|^2)$, $\nabla W=O(\|z\|)$, and its extension is
continuously differentiable at the origin, with derivative zero.

Let

```math
E=R(x^2-y^2)^2+6x^4y^2.
```

Direct differentiation gives the exact identity

```math
\boxed{-\mathcal L_{f_{1,3}}W=\frac{2RA^2 E}{D^4}.}
```

The numerator is positive off the origin. Indeed, if $x^2\ne y^2$,
the first term in $E$ is positive; if $x^2=y^2$ at a nonzero
point, then $6x^4y^2>0$. Thus $W$ is a strict, radially unbounded,
continuously differentiable Lyapunov function. The usual Lyapunov theorem
gives global asymptotic stability. Compact sublevel sets and local
Lipschitz continuity of the cubic field also prevent finite-time escape.

The rational expression is smooth at every nonzero point. Its extension
is not real analytic at the origin, by the analytic obstruction.

## Attribution and exact replay

Liu–Fitzsimmons provide a rational certificate for their parameter-five
example in Section IV.C of [arXiv:2607.16171v1](https://arxiv.org/abs/2607.16171v1).
The displayed expression adapts their construction to parameter three,
where the exact all-degree boundary excludes polynomial and local analytic
weak certificates.

Run `python evidence/verify_all_degree_identities.py` from the repository
root to check the actual Lie derivative identity and the algebraic identities
in the all-degree proof. The analytic existence and obstruction arguments
are proved in the linked supplement.
