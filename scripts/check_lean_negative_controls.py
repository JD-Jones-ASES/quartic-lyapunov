#!/usr/bin/env python3
"""Compile exact identities, then require isolated algebraic mutations to fail."""
import json
from pathlib import Path
import subprocess

ROOT = Path(__file__).resolve().parents[1]
WORK = ROOT / '.lake/verification/negative-controls'
WORK.mkdir(parents=True, exist_ok=True)
HEADER = 'module\nimport QuarticLyapunov.SexticApplication\nopen QuarticLyapunov\n'
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
SEXTIC = '''example (x y : ℝ) :
    sextic ![34,-296,1247,-2850,3606,-2358,634] x y =
      34*(x^3-74/17*x^2*y+109/17*x*y^2-99/34*y^3)^2 +
      2835/17*(x^2*y-1282/567*x*y^2+1213/945*y^3)^2 +
      37250/567*(x*y^2-17079/18625*y^3)^2 + 585833/37250*y^6 := by
  simp [sextic]
  ring
'''
SEXTIC_DERIVATIVE = '''example (x y : ℝ) :
    -10*sexticLie (9/4) ![34,-296,1247,-2850,3606,-2358,634] x y =
      410*(x^4-35/41*x^3*y-3384/205*x^2*y^2+6811/205*x*y^3-3201/205*y^4)^2 +
      91/41*(x^3*y-597/91*x^2*y^2+1006/91*x*y^3-71/13*y^4)^2 +
      4528/455*(x^2*y^2-8807/4528*x*y^3+4837/4528*y^4)^2 +
      38297/4528*(x*y^3-35179/38297*y^4)^2 + 15885/38297*y^8 := by
  rw [sexticLie_eq]
  simp [sexticGradient, field]
  ring
'''
cases = [
    ('valid-identities', QUARTIC + DUAL + SEXTIC + SEXTIC_DERIVATIVE, True),
    ('altered-quartic', QUARTIC.replace('![2,-9', '![3,-9'), False),
    ('altered-parameter', QUARTIC.replace('-lie 2 ', '-lie (5/2) '), False),
    ('altered-dual-weight', DUAL.replace('1051*', '1052*'), False),
    ('altered-sextic', SEXTIC.replace('![34,-296', '![35,-296'), False),
    ('altered-sextic-parameter',
     SEXTIC_DERIVATIVE.replace('sexticLie (9/4)', 'sexticLie (5/2)'), False),
    ('altered-sextic-sos-weight',
     SEXTIC_DERIVATIVE.replace('15885/38297*y^8', '15886/38297*y^8'), False),
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
print('Lean controls passed: original identities compile; six isolated mutations rejected')
