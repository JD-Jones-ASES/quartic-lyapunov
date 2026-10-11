#!/usr/bin/env python3
"""Check source hygiene, module headers, pins, and standalone documentation."""
from pathlib import Path
import json
import re
ROOT=Path(__file__).resolve().parents[1]
config=json.loads((ROOT/'comparator.json').read_text())
challenge=ROOT/(config['challenge_module']+'.lean')
files=list((ROOT/'QuarticLyapunov').glob('*.lean'))+list(ROOT.glob('*.lean'))
for path in files:
    s=path.read_text()
    if path.is_symlink() or not s.startswith('module\n'):raise SystemExit(f'Invalid module: {path.name}')
    if len(s.splitlines())>10000:raise SystemExit(f'Overlong module: {path.name}')
    if path!=challenge and re.search(r'\b(sorry|admit|axiom|native_decide)\b',s):raise SystemExit(f'Forbidden proof token: {path.name}')
if len(challenge.read_text().splitlines())>1000 or challenge.stat().st_size>102400:raise SystemExit('Challenge too large')
imports=re.findall(r'^(?:public )?import (\S+)',challenge.read_text(),re.M)
if any(not n.startswith('Mathlib') for n in imports):raise SystemExit('Unexpected Challenge dependency')
manifest=json.loads((ROOT/'lake-manifest.json').read_text())
if any(not re.fullmatch('[0-9a-f]{40}',p['rev']) for p in manifest['packages']):raise SystemExit('Unpinned dependency')
for path in list(ROOT.glob('*.md'))+list((ROOT/'docs').glob('*.md'))+list((ROOT/'evidence').glob('*.md')):
    if re.search(r'/Users/|/private/tmp|research/',path.read_text(),re.I):raise SystemExit(f'Nonstandalone reference: {path.name}')
print(f'Source contract passed: {len(files)} Lean modules, Mathlib-only Challenge, pinned manifest, standalone documentation')
