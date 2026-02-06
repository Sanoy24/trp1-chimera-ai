# OpenClaw Integration Specification

## Objective

To publish Project Chimera's "Availability" and "Status" to the OpenClaw network, enabling collaboration with external agents.

## Implementation Plan

### 1. The "Status" MCP Resource

We will expose a generic MCP resource `agent://status` that OpenClaw nodes can poll.

**URI Scheme:** `mcp://<agent_ip>/status`

**Schema:**

```json
{
    "agent_id": "chimera-v1",
    "status": "idle | busy | offline",
    "uptime": "seconds",
    "wallet_address": "0x123...",
    "capabilities": [
        {
            "name": "content_generation",
            "cost": "0.1 USDC",
            "latency_ms": 5000
        }
    ]
}
```

### 2. The "Publication" Skill

A specialized skill `skill_broadcast_availability` will verify the internal state (Health + Wallet Balance) and push a "Heartbeat" to the OpenClaw Discovery Node (if applicable) or update the local MCP endpoint.

### 3. Verification

- The Agent must sign the status payload with its Coinbase AgentKit wallet private key to prove identity.
