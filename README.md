# Project Chimera: Autonomous Influencer Network

> **A FastRender Swarm Implementation for the Agent Social Network**

Welcome to the reference implementation of **Project Chimera**, an autonomous agent system designed to operate persistent, intent-driven AI influencers.

## Architecture

This project implements the **FastRender Swarm** pattern detailed in the [SRS Document](Project%20Chimera%20SRS%20Document%20Autonomous%20Influencer%20Network.md).

- **Planner:** Decomposes high-level goals into execution graphs.
- **Worker:** Stateless execution of atomic tasks (Content Gen, Research).
- **Judge:** Governance layer utilizing Optimistic Concurrency Control (OCC) and Confidence Scoring.
- **MCP (Model Context Protocol):** Universal interface for all external interactions (Twitter, News, Wallet).

## Project Structure

```bash
├── specs/                  # The Source of Truth (Executable Specs)
│   ├── _meta.md            # Vision & Constraints
│   ├── functional.md       # User Stories & Directives
│   ├── technical.md        # API Contracts & DB Schema
│   └── openclaw_integration.md
├── research/               # Architectural Decisions
│   ├── context/            # Domain Research
│   └── tooling_strategy.md # Dev vs. Runtime Tools
├── skills/                 # Agent Capabilities (Python Logic)
│   ├── trend_fetcher/      # Perception Skill
│   ├── content_generator/  # Creative Skill
│   └── transaction_manager/# Economic Skill (Coinbase AgentKit)
├── tests/                  # TDD (Failing Tests by Design)
├── .cursor/rules           # IDE Agent Context
```

## Getting Started

### Prerequisites

- Python 3.12+
- `uv` (Recommended package manager)
- Docker (Optional, for containerized run)

### Setup

Initialize the environment and install dependencies:

```bash
make setup
```

## 🛡️ Governance & Testing

This project adheres to a strict "Governor" pipeline.

| Command           | Action         | Purpose                                             |
| :---------------- | :------------- | :-------------------------------------------------- |
| `make test`       | Run Unit Tests | Verify logic & Spec compliance (TDD).               |
| `make lint`       | Run Ruff       | Ensure code quality & style.                        |
| `make security`   | Run Bandit     | Scan for security vulnerabilities.                  |
| `make spec-check` | Verify Specs   | Ensure project structure matches Spec requirements. |
