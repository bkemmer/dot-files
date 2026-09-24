"""Check that changed JS/HTML/CSS/Jinja files differ from HEAD only in comments.

Run from the repo root: python3 comment_only_check.py [base-ref]   (default HEAD)
Strips {# #}, /* */, // line comments (JS only) and all whitespace, then compares.
Exits 1 and names the files with non-comment changes.
"""

import re
import subprocess
import sys


def strip(src: str, js: bool) -> str:
    src = re.sub(r"\{#.*?#\}", "", src, flags=re.S)
    src = re.sub(r"<!--.*?-->", "", src, flags=re.S)
    src = re.sub(r"/\*.*?\*/", "", src, flags=re.S)
    if js:
        src = re.sub(r"(?m)(^|\s)//.*$", "", src)  # not inside URLs like https://
    return re.sub(r"\s+", "", src)


base = sys.argv[1] if len(sys.argv) > 1 else "HEAD"
files = subprocess.run(
    ["git", "diff", "--name-only", "--diff-filter=M", base, "--",
     "*.js", "*.ts", "*.html", "*.css", "*.jinja", "*.j2"],
    capture_output=True, text=True, check=True,
).stdout.split()
changed = []
for f in files:
    js = f.endswith((".js", ".ts"))
    old = subprocess.run(["git", "show", f"{base}:{f}"], capture_output=True, text=True).stdout
    if strip(old, js) != strip(open(f, encoding="utf-8").read(), js):
        changed.append(f)
print(f"{len(files)} files checked")
for f in changed:
    print("NON-COMMENT CHANGE:", f)
sys.exit(1 if changed else 0)
