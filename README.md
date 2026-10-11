# quartic-lyapunov

Exact quartic Lyapunov certificates for a planar homogeneous cubic family.
Private development for a subsequent GPT Pro review.

For $R=x^2+y^2$, consider

```math
f_b(x,y)=(-R+b(x^2-y^2))(x,y)+R(-y,x),\qquad b\in\mathbb R.
```

The accompanying proof classifies all positive definite real homogeneous
quartics: strict certificates exist exactly for $|b|<B$, and weak certificates
exactly for $|b|\le B$. The endpoint quartic is unique up to positive scaling.
Here $B\approx2.1281535330886186$ and $B^2$ is the unique root above one of

```math
16u^6-92u^5+125u^4-134u^3-103u^2-200u+100=0.
```

The theorem permits all five real quartic coefficients and evaluates the
actual derivative along the field. An explicit integer quartic at $b=2$
is strict although no positive definite homogeneous quadratic is even weak.

The complete classification, endpoint uniqueness and degree-separation
application compile in Lean. The [verification record](VERIFICATION.md)
distinguishes local checks from exact-commit Linux verification. This private
candidate is intended for GPT Pro review before submission.

- [Proof](Proof.md): classification and degree-preserving contraction.
- [Endpoint](docs/Endpoint.md): exact primal and dual certificates.
- [Applications](docs/Applications.md) and [extensions](docs/Extensions.md).
- [Sources](docs/Sources.md): primary literature and bounded overlap audit.
- [Formal architecture](IMPLEMENTATION.md), [review brief](REVIEW.md) and [disclosure](Disclosure.md).
- [Exact replays](evidence/README.md).

```sh
lake build
python evidence/independent_replay.py
```

The pinned Lean and Mathlib revisions are recorded in `lean-toolchain`,
`lakefile.toml` and `lake-manifest.json`. The independent Fraction replay uses
only Python's standard library; the primary replay additionally uses SymPy.
No public release, Palomar submission, registration or human specialist review
has occurred. Worldwide priority remains unestablished.
