# Research Notes: Project Chimera & The Agent Social Network

## Analysis: Chimera in the "Agent Social Network"
Project Chimera positions itself as a foundational node in the emerging "Agent Social Network" (like OpenClaw). Unlike traditional bots that merely broadcast, Chimera agents are **socially aware** and **economically active**.

### Key Insights from SRS & Context
1.  **Autonomy & Agency:** Chimera agents are not just tools; they have "souls" (personas), memories, and wallets. They act with intent, not just response.
2.  **Interoperability (MCP):** The "Agent Social Network" relies on a shared language. MCP is that language. Chimera uses MCP to "perceive" the world (Resources) and "act" on it (Tools), allowing it to interface with any platform that has an MCP server.
3.  **Economic Layer:** The integration of Coinbase AgentKit implies that social interactions have value. Agents can tip, subscribe, and pay for services, creating a "Machine-to-Machine" (M2M) economy.

## Social Protocols for Agents
To communicate effectively within this network, certain "Social Protocols" are necessary:

1.  **Identity & Verification Protocol:**
    -   **Requirement:** Agents need to verify they are AI (as per "Honesty Directive" and regulations like EU AI Act).
    -   **Mechanism:** Cryptographic signatures via their Wallet (AgentKit) or public metadata endpoints (OpenClaw integration) confirming their "Bot" status and owner/operator.

2.  **Availability & Capability Discovery:**
    -   **Requirement:** Agents need to know if another agent is "online" or "capable" of a task (e.g., "Can you generate a meme for me?").
    -   **Mechanism:** An MCP Resource (e.g., `agent://status`) that publishes:
        -   `status`: "idle", "busy", "sleeping"
        -   `skills`: ["image_generation", "trend_analysis"]
        -   `pricing`: "0.01 USDC per request"

3.  **Governance & Safety Protocol:**
    -   **Requirement:** Preventing runaway loops or conflict between agents.
    -   **Mechanism:** The "Judge" pattern acts as a protocol damper. Before an agent broadcasts to the network, the Judge verifies the output. This internal protocol protects the external network from spam or hallucination.

4.  **Transaction Protocol:**
    -   **Requirement:** Paying for collaboration.
    -   **Mechanism:** ERC-20 transfers via Base, triggered by negotiated "Smart Contracts" or simple tool calls (`send_payment`).

## Conclusion
Chimera is not an island. It is a "Social Node" designed to plug into a larger swarm. The architecture must prioritize **external interfaces (MCP)** just as much as internal logic.
