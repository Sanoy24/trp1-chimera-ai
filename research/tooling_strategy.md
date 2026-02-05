# Project Chimera — Tooling & MCP Strategy

## Purpose

This document defines the **developer-facing tools (MCP servers)** used to build
and maintain Project Chimera.

These tools assist human developers and development-time AI agents.
They are **not** runtime skills available to the Chimera agent.

---

## Tool Categories

### Developer Tools (MCP)

- Used during development
- May read/write repository files
- Must respect project rules and specs
- Are NOT autonomous unless explicitly enabled

### Agent Runtime Skills

- Used by Chimera at runtime
- Defined separately in the `skills/` directory
- Never allowed to modify source code directly

---

## Selected MCP Developer Tools

---

### 1. Git MCP (Version Control)

**Purpose**
Provides a standardized interface for version control operations such as
staging, committing, and reviewing changes, enabling traceability between
specifications and code.

**Intended Capabilities**

- Stage file changes
- Create commits with structured metadata
- Support agent-assisted code review and CI workflows

**Policy**

- Git MCP is required before autonomous agents can commit code.
- All commits SHOULD reference relevant specs when applicable.

---

### 2. Filesystem MCP (File Access & Editing)

**Status:** Planned / Conceptual

**Purpose**
Provides controlled, auditable access to the project filesystem for
development-time agents and tools.

**Intended Capabilities**

- Read files from the repository
- Write or modify files with explicit intent
- Enforce read-first access to `specs/`

**Policy**

- Filesystem MCP MUST prevent destructive operations.
- Direct file writes require explicit developer intent.

---

### 3. PostgreSQL MCP (Local Database Inspection)

**Purpose**
PostgreSQL MCP provides **read-only, controlled access** to the local PostgreSQL
database during development and debugging.

Its primary role is to help developers and development-time agents:

- Inspect current database state
- Verify schema and data assumptions
- Debug issues related to persistence and queries

This tool is **not** intended for production use or autonomous data mutation.

---

**Intended Capabilities**

- Execute read-only SQL queries (e.g., `SELECT`, `EXPLAIN`)
- Inspect table schemas and indexes
- View row counts and sample records
- Retrieve database metadata (tables, columns, constraints)

---

**Explicit Non-Capabilities**

- No `INSERT`, `UPDATE`, `DELETE`, or `DROP`
- No schema migrations
- No production database access

---

**Policy**

- PostgreSQL MCP MUST operate in read-only mode.
- Access is limited to local development databases.
- Any future write capability would require explicit human approval.
- This MCP tool is for **debugging and inspection only**, not runtime agent behavior.

---

**Rationale**
Database state is often required to validate assumptions during debugging.
Providing controlled inspection prevents unsafe ad-hoc access while preserving
traceability and safety.
