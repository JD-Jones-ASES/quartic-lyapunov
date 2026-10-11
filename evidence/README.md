# Exact evidence

`endpoint_certificate.py` reconstructs the endpoint using SymPy rational
algebraic-field arithmetic. `independent_replay.py` independently reconstructs
it using only Python's standard-library `Fraction`, including checked modular
inverses, a separate Lie-map derivation, and corruption controls. Both remain
active under `python -O`.

```sh
python evidence/endpoint_certificate.py
python -O evidence/endpoint_certificate.py
python evidence/independent_replay.py
python -O evidence/independent_replay.py
python scripts/generate_endpoint.py
lake build
```

The generator emits real algebraic values, polynomial identities and exact
rational interval proofs. Lean checks the generated proofs using its kernel.
The Python results are not theorem premises. The interval and algebraic
endpoint replays do not establish the analytic contraction lemma.
