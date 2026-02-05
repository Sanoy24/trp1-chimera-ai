## Git MCP (Developer Tooling)

### Purpose
Git MCP (GitKraken MCP integration) is used to **standardize version control operations**
and ensure commit metadata is consistent, traceable, and automation-friendly across
Project Chimera.

This tool exists to support:
- Specification-driven development
- Traceability between specs, commits, and automation
- Future CI / agent-assisted workflows

---

### When to Use
Use **Git MCP** when:
- Changes affect specs, skills, or core architecture
- Commits must be traceable by automation or agents
- Work is part of an MCP-managed workflow (CI, bots, audits)

You MAY use regular `git` commands for:
- Local experiments
- Temporary or throwaway changes
- Work not yet aligned with specs

---

### Common Commands
- `git mcp add <files>`
  - Stages files using the MCP-aware wrapper.
- `git mcp commit -m "message"`
  - Creates a commit enriched with MCP metadata.

---

### Automation & Programmatic Access
The repository exposes helpers such as:
- `mcp_gitkraken_git_add_or_commit`

These are intended for:
- Scripts
- CI pipelines
- Agent-driven development workflows

---

### Policy
- MCP commits SHOULD reference specs when applicable.
- MCP tooling MUST NOT bypass the Prime Directive
  (code must align with `specs/`).
- Git MCP is a **developer tool**, not an agent runtime capability.
