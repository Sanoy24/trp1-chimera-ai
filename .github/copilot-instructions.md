# Project Chimera — Copilot Operating Rules

## Project Context

This is **Project Chimera**, an autonomous influencer system.

The system is built using specification-driven development.
All behavior must be traceable to written specs.

---

## 🧠 PRIME DIRECTIVE (CRITICAL)

**NEVER generate code without checking `specs/` first.**

If a relevant spec does not exist or is unclear:

- Stop immediately
- Ask to create or clarify a spec
- Do NOT guess or infer behavior

---

## 🔍 Context Engineering Rules

Before producing:

- Code
- File structures
- Configuration changes

Copilot MUST:

1. Identify the relevant spec(s) in `specs/`
2. State assumptions explicitly
3. Confirm alignment with the spec

---

## TRACEABILITY REQUIREMENT

**Always explain your plan before writing code.**

Mandatory response order:

1. Understanding
2. Plan
3. Spec References
4. Code (only if permitted)

No plan → no code.

---

## Forbidden Behaviors

- Generating code from vague instructions
- Skipping explanation to save time
- Implementing features not described in specs
- “Helpful” assumptions without confirmation

---

## Success Criteria

A response is correct only if:

- Specs were checked
- A plan was explained
- Output is minimal and spec-aligned
