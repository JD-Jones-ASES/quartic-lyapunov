#!/usr/bin/env python3
"""Audit the compared declarations and every public supporting theorem."""
import json
from pathlib import Path
import re
import subprocess
ROOT=Path(__file__).resolve().parents[1]
config=json.loads((ROOT/'comparator.json').read_text())
principal=config['theorem_names']+config.get('definition_names',[])
support=[]
for path in sorted((ROOT/'QuarticLyapunov').glob('*.lean')):
    source=path.read_text()
    ns=re.search(r'^namespace ([\w.]+)',source,re.M).group(1)
    support += [ns+'.'+m for m in re.findall(r'^theorem (\w+)',source,re.M)]
names=list(dict.fromkeys(principal+support))
work=ROOT/'.lake/verification';work.mkdir(parents=True,exist_ok=True)
source=work/'AxiomAudit.lean'
source.write_text('module\nimport QuarticLyapunovSolution\n'+'\n'.join('#print axioms '+n for n in names)+'\n')
proc=subprocess.run(['lake','env','lean',str(source)],cwd=ROOT,text=True,capture_output=True)
output=proc.stdout+proc.stderr
(work/'axioms.log').write_text(output)
if proc.returncode:raise SystemExit(output)
report={}
for name in names:
    found=re.findall(re.escape("'"+name+"'")+r' depends on axioms:\s*\[([^]]*)\]',output)
    empty=re.findall(re.escape("'"+name+"'")+r' does not depend on any axioms',output)
    if len(found)+len(empty)!=1:raise SystemExit('Missing axiom report: '+name)
    used=set() if empty else {a.strip() for a in found[0].split(',') if a.strip()}
    if used-{'propext','Classical.choice','Quot.sound'}:raise SystemExit('Unpermitted axioms: '+name+str(used))
    report[name]=sorted(used)
(work/'axioms.json').write_text(json.dumps(report,indent=2)+'\n')
print(f'Permitted-axiom audit passed: {len(principal)} compared declarations and {len(names)-len(principal)} supporting theorems')
