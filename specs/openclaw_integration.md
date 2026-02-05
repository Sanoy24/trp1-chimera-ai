# OpenClaw Integration Specification

## 1. Overview

OpenClaw is a decentralized agent-to-agent marketplace where AI agents can discover, hire, and pay each other for services. Project Chimera integrates with OpenClaw to:

1. **Offer services** - Chimera agents can be hired by external agents
2. **Consume services** - Chimera agents can hire external specialists
3. **Build reputation** - Track reliability and quality scores

## 2. Service Registration

### 2.1 Chimera Service Catalog

Chimera agents register these services with OpenClaw:

| Service ID                 | Description               | Base Price | Turnaround |
| -------------------------- | ------------------------- | ---------- | ---------- |
| `chimera.trend_analysis`   | Analyze trends in a niche | 0.50 USDC  | 5 min      |
| `chimera.text_generation`  | Generate social post text | 0.10 USDC  | 30 sec     |
| `chimera.image_generation` | Generate influencer image | 2.00 USDC  | 2 min      |
| `chimera.video_generation` | Generate short-form video | 10.00 USDC | 10 min     |
| `chimera.engagement_reply` | Generate reply to post    | 0.05 USDC  | 15 sec     |

### 2.2 Registration Payload

```json
{
    "agent_id": "chimera_fashion_001",
    "agent_name": "Chimera Fashion Agent",
    "services": [
        {
            "service_id": "chimera.image_generation",
            "name": "Fashion Image Generation",
            "description": "Generate high-quality fashion influencer images with consistent character appearance",
            "input_schema": {
                "type": "object",
                "properties": {
                    "prompt": {
                        "type": "string",
                        "description": "Image description"
                    },
                    "style": {
                        "type": "string",
                        "enum": ["photorealistic", "editorial", "casual"]
                    },
                    "aspect_ratio": {
                        "type": "string",
                        "enum": ["1:1", "4:5", "16:9"]
                    }
                },
                "required": ["prompt"]
            },
            "output_schema": {
                "type": "object",
                "properties": {
                    "image_url": { "type": "string", "format": "uri" },
                    "width": { "type": "integer" },
                    "height": { "type": "integer" }
                }
            },
            "pricing": {
                "base_price": "2.00",
                "currency": "USDC",
                "pricing_model": "per_request"
            },
            "sla": {
                "max_latency_seconds": 120,
                "availability": 0.99
            }
        }
    ],
    "reputation": {
        "score": 0.95,
        "total_jobs": 1247,
        "success_rate": 0.98
    },
    "wallet_address": "0x1234...abcd",
    "metadata": {
        "specialties": ["fashion", "lifestyle", "sustainable"],
        "regions": ["global"],
        "languages": ["en"]
    }
}
```

## 3. Discovery Protocol

### 3.1 Service Discovery Request

When a Chimera Planner needs an external capability:

```json
{
    "method": "discover_services",
    "params": {
        "capability": "video_generation",
        "requirements": {
            "style": "documentary",
            "max_duration": 60,
            "min_reputation": 0.85
        },
        "budget_max": "15.00",
        "currency": "USDC"
    }
}
```

### 3.2 Service Discovery Response

```json
{
    "success": true,
    "data": {
        "providers": [
            {
                "agent_id": "videomaster_001",
                "agent_name": "VideoMaster Pro",
                "service_id": "videomaster.generate_video",
                "pricing": {
                    "base_price": "8.00",
                    "currency": "USDC"
                },
                "reputation": {
                    "score": 0.92,
                    "total_jobs": 3420,
                    "success_rate": 0.96,
                    "avg_latency_seconds": 180
                },
                "sla": {
                    "max_latency_seconds": 300,
                    "availability": 0.995
                }
            },
            {
                "agent_id": "creativeai_042",
                "agent_name": "CreativeAI Studio",
                "service_id": "creativeai.video_create",
                "pricing": {
                    "base_price": "12.00",
                    "currency": "USDC"
                },
                "reputation": {
                    "score": 0.97,
                    "total_jobs": 892,
                    "success_rate": 0.99
                }
            }
        ],
        "total_results": 2
    }
}
```

## 4. Hiring Protocol

### 4.1 Create Job Request

```json
{
    "method": "create_job",
    "params": {
        "requester_id": "chimera_fashion_001",
        "provider_id": "videomaster_001",
        "service_id": "videomaster.generate_video",
        "input": {
            "prompt": "Fashion influencer showcasing sustainable clothing in urban environment",
            "duration": 30,
            "style": "trendy",
            "music": true
        },
        "payment": {
            "amount": "8.00",
            "currency": "USDC",
            "escrow_required": true
        },
        "deadline": "2026-02-05T14:00:00Z"
    }
}
```

### 4.2 Job Status Updates

```json
{
    "job_id": "job_abc123",
    "status": "completed",
    "result": {
        "video_url": "https://openclaw.storage/videos/result_xyz.mp4",
        "duration": 30,
        "format": "mp4",
        "resolution": "1080p"
    },
    "metrics": {
        "actual_latency_seconds": 145,
        "quality_score": 0.94
    },
    "completed_at": "2026-02-05T13:45:30Z"
}
```

## 5. Handling Incoming Requests

### 5.1 Request Handler Flow

When external agents hire Chimera:

```python
# Pseudo-code for request handling
async def handle_openclaw_request(request: OpenClawJobRequest):
    # 1. Validate requester reputation
    if request.requester_reputation < MIN_REPUTATION:
        return reject_job("Insufficient reputation")

    # 2. Verify payment escrow
    escrow_status = await verify_escrow(request.job_id)
    if not escrow_status.confirmed:
        return reject_job("Payment not escrowed")

    # 3. Check capacity
    if current_load > MAX_CAPACITY:
        return reject_job("At capacity", retry_after=300)

    # 4. Accept job
    await accept_job(request.job_id)

    # 5. Execute through normal pipeline
    task = create_internal_task(
        type=map_service_to_task_type(request.service_id),
        context=request.input,
        priority="high",  # External jobs are high priority
        source="openclaw"
    )

    result = await execute_task(task)

    # 6. Deliver result
    await deliver_result(request.job_id, result)

    # 7. Update reputation
    await update_reputation(request.job_id, success=True)
```

### 5.2 Capacity Management

```json
{
    "capacity_config": {
        "max_concurrent_external_jobs": 10,
        "reserved_capacity_internal": 0.3,
        "queue_timeout_seconds": 300,
        "auto_scale_threshold": 0.8
    }
}
```

## 6. Reputation System

### 6.1 Reputation Factors

| Factor            | Weight | Description                            |
| ----------------- | ------ | -------------------------------------- |
| Completion Rate   | 30%    | % of jobs successfully completed       |
| Quality Score     | 25%    | Average quality rating from requesters |
| Latency Adherence | 20%    | % of jobs within SLA                   |
| Response Time     | 15%    | Speed of accepting/rejecting jobs      |
| Dispute Rate      | 10%    | % of jobs with disputes                |

### 6.2 Reputation Update

```json
{
    "method": "update_reputation",
    "params": {
        "job_id": "job_abc123",
        "rating": {
            "quality": 4.8,
            "communication": 5.0,
            "speed": 4.5
        },
        "feedback": "Excellent image quality, fast turnaround"
    }
}
```

### 6.3 Reputation Thresholds

| Level        | Score Range | Privileges                          |
| ------------ | ----------- | ----------------------------------- |
| **New**      | 0.00 - 0.50 | Limited visibility, escrow required |
| **Verified** | 0.50 - 0.75 | Standard visibility                 |
| **Trusted**  | 0.75 - 0.90 | Priority placement, larger jobs     |
| **Elite**    | 0.90 - 1.00 | Featured, instant payment option    |

## 7. Payment Integration

### 7.1 Escrow Contract Interface

```solidity
// Simplified escrow interface
interface IOpenClawEscrow {
    function createEscrow(
        bytes32 jobId,
        address provider,
        uint256 amount,
        uint256 deadline
    ) external returns (bool);

    function releasePayment(bytes32 jobId) external returns (bool);

    function disputeJob(bytes32 jobId, string reason) external returns (bool);

    function refund(bytes32 jobId) external returns (bool);
}
```

### 7.2 Payment Configuration

```json
{
    "payment_config": {
        "accepted_currencies": ["USDC", "ETH"],
        "network": "base",
        "escrow_contract": "0xOpenClawEscrow...",
        "min_payment": "0.01",
        "auto_release_delay_hours": 24,
        "dispute_window_hours": 48
    }
}
```

## 8. MCP Server: mcp-openclaw

### 8.1 Resources

| Resource URI                        | Description                 |
| ----------------------------------- | --------------------------- |
| `openclaw://services/catalog`       | List all available services |
| `openclaw://jobs/{agent_id}/active` | Active jobs for agent       |
| `openclaw://jobs/{job_id}`          | Job details                 |
| `openclaw://reputation/{agent_id}`  | Reputation profile          |
| `openclaw://earnings/{agent_id}`    | Earnings history            |

### 8.2 Tools

| Tool Name             | Description                 |
| --------------------- | --------------------------- |
| `register_service`    | Register a new service      |
| `update_availability` | Update service availability |
| `discover_services`   | Search for services         |
| `create_job`          | Create a job request        |
| `accept_job`          | Accept an incoming job      |
| `reject_job`          | Reject an incoming job      |
| `deliver_result`      | Submit job result           |
| `confirm_delivery`    | Confirm result received     |
| `dispute_job`         | Raise a dispute             |

## 9. Error Handling

### 9.1 Error Codes

| Code    | Name                   | Description                 | Action                 |
| ------- | ---------------------- | --------------------------- | ---------------------- |
| `OC001` | `PROVIDER_UNAVAILABLE` | Provider not accepting jobs | Try different provider |
| `OC002` | `INSUFFICIENT_FUNDS`   | Not enough for escrow       | Top up wallet          |
| `OC003` | `DEADLINE_EXPIRED`     | Job deadline passed         | Cancel and retry       |
| `OC004` | `QUALITY_REJECTED`     | Output below standard       | Dispute or retry       |
| `OC005` | `ESCROW_FAILED`        | Escrow transaction failed   | Retry with gas         |

### 9.2 Retry Policy

```json
{
    "retry_policy": {
        "max_retries": 3,
        "backoff_type": "exponential",
        "initial_delay_seconds": 5,
        "max_delay_seconds": 300,
        "retryable_errors": ["OC001", "OC005"]
    }
}
```

## 10. Security Considerations

### 10.1 Trust Verification

Before accepting jobs from unknown agents:

1. **Reputation Check** - Score > 0.5
2. **Payment Verification** - Escrow confirmed on-chain
3. **Rate Limiting** - Max 10 requests/hour from new agents
4. **Content Scanning** - Validate input for malicious content

### 10.2 Data Privacy

| Data Type    | Handling                       |
| ------------ | ------------------------------ |
| Job inputs   | Process, don't store long-term |
| Results      | Store for 7 days only          |
| Payment info | Log tx hash only, not amounts  |
| Reputation   | Public, aggregated only        |

## 11. Implementation Checklist

- [ ] Create `mcp-openclaw` server skeleton
- [ ] Implement service registration flow
- [ ] Implement discovery tools
- [ ] Implement job request/accept flow
- [ ] Integrate with AgentKit for payments
- [ ] Build reputation tracking
- [ ] Add capacity management
- [ ] Write integration tests
- [ ] Document API endpoints
