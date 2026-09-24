---
name: translate-codebase
description: Translate a codebase from one natural language to another (typically Portuguese or Spanish to English) — docstrings, comments and docs first, then file names, functions, classes, variables, tests, routes, query/form params, CSS classes, config keys, env vars and infra comments — while keeping UI text, data values and external formats untouched, and proving each step changed only what it should. Use whenever the user wants code, comments, docs, identifiers or "everything" in a repo moved to English (or another language), asks to "make the docs clearer" in a repo written in mixed languages, wants a bilingual README, or wants to rename Portuguese/Spanish/etc. files, routes or functions — even if they only mention one of these layers.
---

# Translate a codebase

A repo in mixed languages is hard to read and harder to search. The job is to move every
layer that is *code* to the target language, leave every layer that is *product or data*
alone, and prove at each step that behaviour didn't change by accident.

Work in layers, from safest to riskiest. Each layer is shippable on its own, and the
user may want to stop after any of them.

| Layer | What | Changes behaviour? |
|---|---|---|
| 1. Docs | docstrings, comments, README, plans, skill docs | no — prove it |
| 2. Names | file names, functions, classes, methods, fixtures, test names, locals | no (internal) |
| 3. Surface | routes, query/form params, CSS classes, JS names, config keys, env vars, messages, infra comments | **yes** — needs redirects, deploy care |

## 0. Decide before touching anything

Read the repo's own conventions (git log, CLAUDE.md/AGENTS.md, memory) and look for an
earlier translation commit — it tells you what was already decided. Then settle, asking
the user only what you can't infer:

- **Target language** for code, comments, docstrings (usually English).
- **What stays in the source language.** The usual answer, and the right default:
  - UI strings (labels, buttons, messages the end user reads);
  - data values (category names, account names, enum values that are also shown on
    screen, fixture descriptions);
  - external formats: CSV headers, JSON keys and folder names that come from banks,
    stores, APIs or a server's disk. Renaming these breaks imports or needs a data
    migration on the server.
- **Commit/PR language.** Check the user's global instructions; they can differ from the
  repo's history.
- **README:** usually the main README in the target language plus a copy in the source
  language (`README.pt-br.md`), each linking to the other.
- **Domain terms** with no good translation (e.g. *rateio*): pick one English name for
  code (`split`) and keep the original word in UI and docs with a gloss on first use.

Record the decision where future sessions will see it (memory or CLAUDE.md), so the
repo doesn't drift back.

## 1. Docs and comments

Inventory first: `git ls-files`, then count lines per file so you know the size.

Rewrite rules that made the difference:

1. The first line says what the thing does or returns.
2. Keep the *why* only when it isn't obvious from the code: constraints, traps, reasons
   for a threshold. Drop the story of how the code got here ("these used to live in three
   places…"), unless it warns against going back.
3. Fix stale facts as you go: grep for old tech names (e.g. `sqlite`, removed files) and
   check each claim against the code. Translation is the moment these get caught.
4. Numbers that will rot ("11 rows today") go, or get a "measured on <date>" when they
   justify a design choice (use `git log -S` to find the date).
5. Short sentences, bullets for lists of rules.
6. Domain terms keep their original word, in backticks or with a gloss.

**Prove nothing but comments changed:**
- Python: `python3 scripts/ast_docstring_check.py` (compares the AST of HEAD and the
  working tree with docstrings stripped; comments aren't in the AST).
- JS/HTML/CSS/Jinja: `python3 scripts/comment_only_check.py` (strips `//`, `/* */`,
  `{# #}` and whitespace, then compares).
- Then lint and the test suite.

## 2. Names

Inventory every identifier instead of guessing: `python3 scripts/list_identifiers.py`
prints all Python NAME tokens in the repo; eyeball it for source-language words. For JS,
grep `function |const |let `.

Rename files with plain `mv` (not `git mv`) if the user doesn't want you staging; update
every reference (imports, templates, docs, skills, Makefile). Grep for the old names
afterwards, excluding historical folders (`plans/executed`, handoffs) that are records.

Rename test functions and fixtures too; parametrize strings (`"method, route"`) must
match the renamed parameters.

## 3. Surface

This layer changes what the outside world sees. For each kind:

- **Routes:** rename, and add permanent (301) redirects for the old **GET** URLs,
  preserving the query string — bookmarks and phone home-screen shortcuts depend on them.
  POST targets only need the forms updated. Add a test for the redirects.
- **Query/form params and notices:** change in handlers, templates, JS and tests together.
- **CSS classes and variables:** rename in the stylesheet, HTML, JS selectors and tests in
  one go. Before reusing a short name (`.card`, `.guess`), check it isn't already a class
  with its own styles — cascade collisions look fine in tests and wrong on screen.
- **Config keys:** rename in the file and the loader, then *verify the file's keys are
  actually read*: loaders with defaults hide a mismatch completely (the defaults equal the
  old values, so tests stay green). A one-liner asserting the loaded keys catches it.
- **Env vars:** rename in code, compose files, `.env.example`, docs and tests. Check whether
  the production environment sets it; if so, the deploy needs a coordinated change.
- **Messages** in scripts, assertions and logs: translate; UI strings stay.
- **Infra and hooks** (Makefile help and comments, Dockerfile, compose, pre-commit, git
  hooks, `.gitignore`): translate the comments; rename Make variables users may pass.

## Pitfalls that bit last time

- **Regex renames also hit string literals.** A local named like an external key
  (`parcelamento`) got renamed *inside* `rec.get("parcelamento")`, silently breaking an
  import; only a test caught it. After a regex pass, list every changed string literal
  (`git diff -U0 | grep '^+' | grep -o '"[^"]*"' | sort -u`) and check each one.
- **`re.sub` replacement strings interpret escapes**: a `"\\n"` you meant to keep literal
  becomes a real newline and breaks the file. Use a function replacement, or re-check
  with the linter right after.
- **New names can collide with existing locals** (renaming param `palpite` → `guess` when
  `guess = Guesser(...)` already exists in the same function). Read each function you
  touch.
- **A multi-step rename script that fails halfway leaves some files done.** Make each
  step idempotent or assert-and-stop before writing, and never re-run a whole script
  blindly.
- **Environment overrides:** compose `environment:` beats a shell prefix
  (`FOO=x docker compose run`); use `-e FOO=x` and verify inside the container before
  writing to anything that could be the real database.

## Verify for real

Tests alone miss CSS, JS and redirects. After layer 3:

1. Full suite + lint.
2. Run the app on a **copy** of the database and data (never the real ones), confirm
   inside the container which database it uses, then click through every page: every
   link returns 200, old URLs redirect, filters, saving, panels, the phone view. Look at
   screenshots — a page can load without errors and still be broken.
3. After deploy, check the public URL: login guard, redirects, static assets, no console
   errors. Don't write to production data while testing.

## Ship

One commit per layer is easiest to review; one commit is fine if the user prefers. The PR
body should have a before → after table of every renamed route, param, config key and env
var, a "what stays" list, and a compatibility section (redirects, deploy steps, data that
needs migrating).
