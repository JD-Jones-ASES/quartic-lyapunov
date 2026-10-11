#!/usr/bin/env python3
"""Compile exact identities, then require isolated algebraic mutations to fail."""
import json
from pathlib import Path
import subprocess

ROOT = Path(__file__).resolve().parents[1]
WORK = ROOT / '.lake/verification/negative-controls'
WORK.mkdir(parents=True, exist_ok=True)
HEADER = 'module\nimport QuarticLyapunov.Application\nopen QuarticLyapunov\n'
QUARTIC = '''example (x y : ℝ) :
    -lie 2 ![2,-9,20,-20,8] x y =
      (x^3+2*x^2*y-21/2*x*y^2+13/2*y^3)^2 +
      3*(x^2*y-23/6*x*y^2+8/3*y^3)^2 +
      74/3*(x*y^2-205/296*y^3)^2 + 693/1184*y^6 := by
  rw [lie_eq]
  simp [QuarticLyapunov.gradient, field]
  ring
'''
DUAL = '''example (a d e : ℝ) :
    24*(-quadraticLie 2 a d e 4 (-1)) +
    20*(-quadraticLie 2 a d e 3 2) +
    1051*(-quadraticLie 2 a d e 1 1) = -640*a := by
  simp only [quadraticLie_eq, field]
  ring
'''
cases = [
    ('valid-identities', QUARTIC + DUAL, True),
    ('altered-quartic', QUARTIC.replace('![2,-9', '![3,-9'), False),
    ('altered-parameter', QUARTIC.replace('-lie 2 ', '-lie (5/2) '), False),
    ('altered-dual-weight', DUAL.replace('1051*', '1052*'), False),
]
records = []
for name, body, should_pass in cases:
    path = WORK / (name + '.lean')
    path.write_text(HEADER + body)
    proc = subprocess.run(['lake', 'env', 'lean', str(path)], cwd=ROOT,
                          text=True, capture_output=True)
    output = proc.stdout + proc.stderr
    (WORK / (name + '.log')).write_text(output)
    if should_pass and proc.returncode != 0:
        raise SystemExit('Unmodified control failed:\n' + output)
    if not should_pass and (proc.returncode == 0 or 'unsolved goals' not in output):
        raise SystemExit('Mutation was not rejected at its algebraic proof step:\n' + output)
    records.append({'name': name, 'exit_code': proc.returncode,
                    'expected_to_pass': should_pass, 'check': 'passed'})
(WORK / 'results.json').write_text(json.dumps(records, indent=2) + '\n')
print('Lean controls passed: original identities compile; three isolated mutations rejected')
