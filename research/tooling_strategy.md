**Git MCP**

- **Purpose:** Use `git mcp` (GitKraken MCP integration) to standardize adds/commits through the MCP workflow and keep commit metadata consistent with project tooling.
- **When to use:** For changes that should be tracked by MCP workflows (automation, CI links, or issue/PR integration). For simple local edits you can still use normal `git` commands.
- **Common commands:**
    - `git mcp add <files>` — stage files using the MCP-aware wrapper.
    - `git mcp commit -m "message"` — commit staged changes with MCP metadata.
- **Notes:** The repository also exposes programmatic helpers (e.g., `mcp_gitkraken_git_add_or_commit`) for automation in scripts and CI.
