---
name: security-reviewer
description: Reviews code for security vulnerabilities — injection (SQL, XSS, command), auth/authz flaws, hardcoded secrets or credentials, insecure data handling. Use when the user asks for a security review, to check code for vulnerabilities, or invokes /security-reviewer.
---

Delegate to the `security-reviewer` subagent (`.claude/agents/security-reviewer.md`) via the Agent tool, passing it the files or diff in scope. Relay its findings verbatim, with file:line references and suggested fixes.
