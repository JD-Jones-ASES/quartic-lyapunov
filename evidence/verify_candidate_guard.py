#!/usr/bin/env python3
"""Meaningful controls for exact-candidate provenance, without starting Lean."""
import importlib.util
from pathlib import Path
import subprocess
import tempfile

ROOT = Path(__file__).resolve().parents[1]
spec = importlib.util.spec_from_file_location("kernel_guard",
                                           ROOT / "scripts/verify_kernels.py")
module = importlib.util.module_from_spec(spec)
spec.loader.exec_module(module)


def git(root, *args):
    return subprocess.check_output(["git", "-c", "core.hooksPath=/dev/null",
                                    "-c", "commit.gpgsign=false", *args], cwd=root, text=True,
                                   stderr=subprocess.DEVNULL).strip()


def rejected(root, label):
    try:
        module.require_clean_candidate(root)
    except SystemExit as error:
        if "clean checkout" not in str(error):
            raise RuntimeError(f"{label}: unexpected rejection {error}")
    else:
        raise RuntimeError(f"{label}: dirty checkout was accepted")
    print(f"PASS {label}")


with tempfile.TemporaryDirectory(prefix="quartic-candidate-guard-") as directory:
    root = Path(directory)
    git(root, "init", "-q")
    (root / "certificate.txt").write_text("original\n")
    (root / ".gitignore").write_text("ignored-output/\n")
    git(root, "add", ".")
    git(root, "-c", "user.name=Verification fixture",
        "-c", "user.email=fixture@example.invalid", "commit", "-qm", "fixture")
    sha = git(root, "rev-parse", "HEAD")
    if module.require_clean_candidate(root) != sha:
        raise RuntimeError("clean candidate SHA mismatch")
    print("PASS clean checkout records its actual commit")
    (root / "certificate.txt").write_text("altered\n")
    rejected(root, "modified tracked certificate rejected")
    git(root, "add", "certificate.txt")
    rejected(root, "staged certificate change rejected")
    git(root, "reset", "--quiet", "HEAD", "--", "certificate.txt")
    git(root, "checkout", "--", "certificate.txt")
    (root / "certificate.txt").unlink()
    rejected(root, "deleted tracked certificate rejected")
    git(root, "checkout", "--", "certificate.txt")
    (root / "untracked.lean").write_text("-- untracked candidate source\n")
    rejected(root, "untracked candidate source rejected")
    (root / "untracked.lean").unlink()
    (root / "ignored-output").mkdir()
    (root / "ignored-output/log.txt").write_text("generated output\n")
    if module.require_clean_candidate(root) != sha:
        raise RuntimeError("ignored output changed the source candidate")
    print("PASS ignored generated output does not invalidate clean sources")
