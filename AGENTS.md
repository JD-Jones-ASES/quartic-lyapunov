# quartic-lyapunov

Read [README](README.md), [Verification](VERIFICATION.md),
[Formal architecture](IMPLEMENTATION.md) and [Proof](Proof.md) before changing
the formal contract. The repository is public; preserve its visibility unless
JD explicitly requests a change.

Preserve arbitrary real quartic coefficients, every nonzero real point and
the actual Lie derivative. Do not replace the classification by sampled
inequalities, coefficient restrictions or conditional certificate existence.
Preserve the full endpoint derivative cone and the literal sextic certificate.

Keep written analytic results distinct from finite exact replay and formal
verification. The Challenge must import only Mathlib; the Solution must contain
no proof placeholders. Permit only `propext`, `Classical.choice` and
`Quot.sound` in theorem dependencies.

After formal changes, run source and evidence checks, the full build, axiom
audits and negative controls. Claim release verification only after Comparator,
independent-kernel replay and a fresh Linux build pass on the exact commit.
Use coherent `codex/` branches and keep standalone documentation focused on
mathematics, proof architecture and reproducible evidence.
