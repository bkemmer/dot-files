"""Check that changed Python files differ from HEAD only in docstrings and comments.

Run from the repo root: python3 ast_docstring_check.py [base-ref]   (default HEAD)
Comments are not in the AST, and docstrings are stripped before comparing, so identical
dumps mean no code changed. Exits 1 and names the files whose code changed.
"""

import ast
import subprocess
import sys


def strip(src: str) -> str:
    tree = ast.parse(src)
    for node in ast.walk(tree):
        body = getattr(node, "body", None)
        if (
            isinstance(body, list)
            and body
            and isinstance(body[0], ast.Expr)
            and isinstance(getattr(body[0], "value", None), ast.Constant)
            and isinstance(body[0].value.value, str)
        ):
            node.body = body[1:] or [ast.Pass()]
    return ast.dump(tree)


base = sys.argv[1] if len(sys.argv) > 1 else "HEAD"
files = subprocess.run(
    ["git", "diff", "--name-only", "--diff-filter=M", base, "--", "*.py"],
    capture_output=True, text=True, check=True,
).stdout.split()
changed = []
for f in files:
    old = subprocess.run(["git", "show", f"{base}:{f}"], capture_output=True, text=True).stdout
    if strip(old) != strip(open(f, encoding="utf-8").read()):
        changed.append(f)
print(f"{len(files)} files checked")
for f in changed:
    print("CODE CHANGED:", f)
sys.exit(1 if changed else 0)
