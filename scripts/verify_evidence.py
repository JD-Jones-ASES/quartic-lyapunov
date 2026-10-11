#!/usr/bin/env python3
"""Replay exact finite evidence; analytic and Lean proofs are checked separately."""
from pathlib import Path
import hashlib
import json
import subprocess
import sys

ROOT = Path(__file__).resolve().parents[1]
WORK = ROOT / ".lake/verification/evidence"
REPLAYS = [
    "evidence/endpoint_certificate.py",
    "evidence/independent_replay.py",
    "evidence/verify_semantics.py",
    "evidence/verify_quadratic_boundary.py",
    "evidence/verify_sextic_certificate.py",
    "evidence/verify_all_degree_identities.py",
]


def main():
    WORK.mkdir(parents=True, exist_ok=True)
    # A failed rerun must not leave a previous complete source manifest behind.
    (WORK / "source-sha256.json").unlink(missing_ok=True)
    (WORK / "results.json").write_text("[]\n")
    commands = [(name, [sys.executable, name]) for name in (
        "scripts/check_sources.py", "scripts/validate_metadata.py",
    )]
    guard = "evidence/verify_candidate_guard.py"
    commands.extend([(guard, [sys.executable, guard]),
                     (guard + " (-O)", [sys.executable, "-O", guard])])
    for path in REPLAYS:
        commands.extend([
            (path, [sys.executable, path]),
            (path + " (-O)", [sys.executable, "-O", path]),
        ])
    records = []
    for index, (label, command) in enumerate(commands):
        result = subprocess.run(command, cwd=ROOT, capture_output=True, text=True)
        output = result.stdout + result.stderr
        log = WORK / f"{index+1:02d}-{Path(command[-1]).stem}{'-optimized' if '-O' in command else ''}.log"
        log.write_text(output)
        records.append({"check": label, "command": command, "exit_code": result.returncode,
                        "log": log.name})
        (WORK / "results.json").write_text(json.dumps(records, indent=2) + "\n")
        if result.returncode:
            raise SystemExit(f"FAILED {label}\n{output}")
        print(f"PASS {label}", flush=True)
    # Honor repository ignore rules without descending into dependency caches.
    source_names = subprocess.check_output(
        ["git", "ls-files", "-z", "--cached", "--others", "--exclude-standard"],
        cwd=ROOT, text=True,
    ).split("\0")
    hashes = {name: hashlib.sha256((ROOT / name).read_bytes()).hexdigest()
              for name in sorted(set(source_names)) if name and (ROOT / name).is_file()}
    (WORK / "source-sha256.json").write_text(json.dumps(hashes, indent=2) + "\n")
    print(f"All {len(records)} finite/source/metadata checks passed.")
    print("The analytic all-degree proof and fresh Lean verification are outside this replay.")


if __name__ == "__main__":
    main()
