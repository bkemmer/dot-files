"""Print every Python identifier used in the repo's tracked .py files, sorted.

Run from the repo root: python3 list_identifiers.py
Scan the output for words in the source language: they are what still needs renaming.
"""

import subprocess
import tokenize

names = set()
files = subprocess.run(["git", "ls-files", "*.py"], capture_output=True, text=True, check=True).stdout.split()
for f in files:
    try:
        with open(f, "rb") as fh:
            names.update(t.string for t in tokenize.tokenize(fh.readline) if t.type == tokenize.NAME)
    except (OSError, SyntaxError, tokenize.TokenError):
        pass
print(" ".join(sorted(names)))
