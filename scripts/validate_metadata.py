#!/usr/bin/env python3
"""Validate against the pinned upstream v0.4 metadata schema."""
import json
from pathlib import Path
import jsonschema
import yaml
root=Path(__file__).resolve().parents[1]
jsonschema.validate(yaml.safe_load((root/'formalization.yaml').read_text()),
                    json.loads((root/'verification/formalization-v0.4.schema.json').read_text()))
print('Upstream formalization.yaml v0.4 schema passed')
