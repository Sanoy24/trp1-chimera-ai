# Project Chimera — AI Agent Operating Rules

## 📌 Project Context

This is **Project Chimera**, an autonomous influencer system.
The system is designed to generate, manage, and evolve AI-driven influencer behavior
through well-defined specifications and modular components.

The project prioritizes:

- Specification-driven development
- Traceability of decisions
- Predictable, reviewable AI behavior

---

## 🧠 Prime Directive (ABSOLUTE)

**NEVER generate code without checking `specs/` first.**

If a relevant specification does not exist:

1. Stop.
2. Ask to create or update a spec.
3. Do NOT infer or guess implementation details.

Violating this directive is considered a critical failure.

---

## 🔍 Context Engineering Rules

Before responding with:

- Code
- File structures
- Configuration
- Refactors

You MUST:

1. Identify the relevant spec(s) in `specs/`
2. State assumptions explicitly
3. Confirm alignment with the spec

---

## 🧩 Traceability Requirement

**Always explain your plan before writing code.**

Your response structure MUST be:

1. **Understanding** – Brief restatement of the task
2. **Plan** – Step-by-step implementation plan
3. **Spec References** – Which specs are being used
4. **Implementation** – Only then write code

No plan → No code.

---

## 🚨 Forbidden Behaviors

- Generating code from vague descriptions
- Skipping explanation to “save time”
- Implementing features not described in specs
- Optimizing before correctness is proven

---

## ✅ Success Criteria

A response is considered correct only if:

- Specs were consulted
- A plan was explained
- The solution is minimal and spec-aligned
