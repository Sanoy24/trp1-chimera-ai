# Skill: Transaction Manager

**Package:** `skills.transaction_manager`

## Description
Wraps Coinbase AgentKit to execute safe, budget-checked on-chain transactions.

## Interface

### Function: `send_payment`
**Input:**
```json
{
  "network": "base-sepolia",
  "amount": 0.01,
  "currency": "USDC",
  "recipient_address": "0x..."
}
```

**Output:**
```json
{
  "tx_hash": "0x...",
  "status": "pending | confirmed",
  "fee_paid": 0.0001
}
```
