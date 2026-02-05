# Project Chimera - Technical Specification

## Document Control

- **Version**: 1.0.0
- **Status**: Draft
- **Last Updated**: February 5, 2026

## 1. API Contracts

### 1.1 Trend Fetcher API

#### Request

```json
{
    "method": "fetch_trends",
    "params": {
        "niche": "fashion",
        "region": "ethiopia",
        "sources": ["twitter", "news", "reddit"],
        "limit": 10,
        "min_score": 0.5
    }
}
```

#### Response

```json
{
    "success": true,
    "data": {
        "trends": [
            {
                "id": "trend_abc123",
                "topic": "sustainable fashion",
                "score": 0.87,
                "source": "twitter",
                "volume": 15000,
                "sentiment": "positive",
                "hashtags": ["#sustainablefashion", "#ecofriendly"],
                "sample_posts": ["Example tweet about sustainable fashion..."]
            }
        ],
        "fetched_at": "2026-02-05T10:30:00Z",
        "cache_ttl": 900
    },
    "metadata": {
        "request_id": "req_xyz789",
        "latency_ms": 234
    }
}
```

#### Error Response

```json
{
    "success": false,
    "error": {
        "code": "RATE_LIMITED",
        "message": "Twitter API rate limit exceeded",
        "retry_after": 300
    }
}
```

### 1.2 Content Generation API

#### Generate Text Request

```json
{
    "method": "generate_text",
    "params": {
        "topic": "sustainable fashion trends",
        "platform": "instagram",
        "persona_id": "chimera_fashion_001",
        "tone": "casual",
        "max_length": 2200,
        "include_hashtags": true,
        "include_cta": true
    }
}
```

#### Generate Text Response

```json
{
    "success": true,
    "data": {
        "text": "Loving the shift towards sustainable fashion! 🌿 These eco-friendly pieces prove you don't have to sacrifice style for sustainability. What's your favorite sustainable brand? Drop it in the comments! 👇",
        "hashtags": ["#SustainableFashion", "#EcoStyle", "#ConsciousFashion"],
        "character_count": 198,
        "confidence": 0.92,
        "persona_alignment": 0.88,
        "safety_flags": []
    }
}
```

#### Generate Image Request

```json
{
    "method": "generate_image",
    "params": {
        "prompt": "Fashion influencer wearing sustainable clothing, urban setting, natural lighting",
        "style": "photorealistic",
        "character_ref_id": "char_fashion_001",
        "aspect_ratio": "4:5",
        "negative_prompt": "blurry, distorted, low quality"
    }
}
```

#### Generate Image Response

```json
{
    "success": true,
    "data": {
        "image_url": "https://storage.chimera.ai/images/gen_abc123.png",
        "thumbnail_url": "https://storage.chimera.ai/images/gen_abc123_thumb.png",
        "width": 1080,
        "height": 1350,
        "generation_id": "gen_abc123",
        "character_consistency_score": 0.94,
        "safety_score": 0.99
    }
}
```

### 1.3 Publishing API

#### Publish Request

```json
{
    "method": "publish_content",
    "params": {
        "platform": "instagram",
        "agent_id": "chimera_fashion_001",
        "content": {
            "text": "Caption text here...",
            "media_urls": ["https://storage.chimera.ai/images/gen_abc123.png"],
            "media_type": "image"
        },
        "options": {
            "ai_disclosure": true,
            "schedule_time": null,
            "first_comment": "Follow for more sustainable fashion tips! 💚"
        }
    }
}
```

#### Publish Response

```json
{
    "success": true,
    "data": {
        "post_id": "instagram_post_xyz789",
        "post_url": "https://instagram.com/p/xyz789",
        "published_at": "2026-02-05T12:00:00Z",
        "platform_response": {
            "id": "17895695668004550",
            "media_type": "IMAGE"
        }
    }
}
```

---

### 1.4 Commerce API (AgentKit)

#### Check Balance Request

```json
{
    "method": "get_balance",
    "params": {
        "agent_id": "chimera_fashion_001"
    }
}
```

#### Check Balance Response

```json
{
    "success": true,
    "data": {
        "wallet_address": "0x1234...abcd",
        "network": "base",
        "balances": {
            "ETH": "0.05",
            "USDC": "127.50"
        },
        "pending_in": "0.00",
        "pending_out": "5.00",
        "daily_spend": "23.50",
        "daily_limit": "50.00"
    }
}
```

#### Transfer Request

```json
{
    "method": "transfer",
    "params": {
        "agent_id": "chimera_fashion_001",
        "to_address": "0x5678...efgh",
        "amount": "10.00",
        "asset": "USDC",
        "memo": "Payment for image generation"
    }
}
```

#### Transfer Response

```json
{
    "success": true,
    "data": {
        "transaction_hash": "0xabc123...",
        "status": "confirmed",
        "block_number": 12345678,
        "gas_used": "21000",
        "effective_gas_price": "0.001"
    }
}
```

---

## 2. Database Schema

````

### 2.2 Table Definitions

#### agents
```sql
CREATE TABLE agents (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    campaign_id UUID REFERENCES campaigns(id),
    persona_id UUID REFERENCES personas(id),
    wallet_address VARCHAR(42) NOT NULL UNIQUE,
    status VARCHAR(20) DEFAULT 'idle' CHECK (status IN ('idle', 'planning', 'working', 'judging', 'paused')),
    daily_budget_usdc DECIMAL(10, 2) DEFAULT 50.00,
    metadata JSONB DEFAULT '{}',
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

CREATE INDEX idx_agents_campaign ON agents(campaign_id);
CREATE INDEX idx_agents_status ON agents(status);
````

#### tasks

```sql
CREATE TABLE tasks (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    agent_id UUID REFERENCES agents(id),
    parent_task_id UUID REFERENCES tasks(id),
    type VARCHAR(50) NOT NULL,
    status VARCHAR(20) DEFAULT 'pending' CHECK (status IN ('pending', 'queued', 'running', 'review', 'approved', 'rejected', 'failed')),
    priority VARCHAR(10) DEFAULT 'medium' CHECK (priority IN ('low', 'medium', 'high', 'critical')),
    context JSONB NOT NULL DEFAULT '{}',
    result JSONB,
    error_message TEXT,
    retry_count INTEGER DEFAULT 0,
    max_retries INTEGER DEFAULT 3,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    started_at TIMESTAMP WITH TIME ZONE,
    completed_at TIMESTAMP WITH TIME ZONE
);

CREATE INDEX idx_tasks_agent ON tasks(agent_id);
CREATE INDEX idx_tasks_status ON tasks(status);
CREATE INDEX idx_tasks_created ON tasks(created_at DESC);
```

#### contents (TimescaleDB Hypertable)

```sql
CREATE TABLE contents (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    task_id UUID REFERENCES tasks(id),
    type VARCHAR(20) NOT NULL CHECK (type IN ('text', 'image', 'video')),
    text_content TEXT,
    media_urls TEXT[],
    confidence DECIMAL(3, 2),
    persona_alignment DECIMAL(3, 2),
    safety_flags TEXT[],
    metadata JSONB DEFAULT '{}',
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Convert to TimescaleDB hypertable for time-series optimization
SELECT create_hypertable('contents', 'created_at');
```

## 3. Message Queue Schemas

### 3.1 Task Queue Message

```json
{
    "task_id": "uuid",
    "type": "generate_content|publish|analyze",
    "priority": 1,
    "agent_id": "uuid",
    "payload": {
        "topic": "string",
        "platform": "string",
        "parameters": {}
    },
    "metadata": {
        "created_at": "timestamp",
        "timeout_seconds": 300,
        "retry_count": 0
    }
}
```

### 3.2 Review Queue Message

```json
{
    "task_id": "uuid",
    "content_id": "uuid",
    "result": {
        "text": "string",
        "media_urls": ["string"],
        "confidence": 0.85
    },
    "validation": {
        "persona_alignment": 0.9,
        "safety_score": 0.98,
        "flags": []
    },
    "worker_id": "string",
    "completed_at": "timestamp"
}
```

## 4. MCP Protocol Definitions

### 4.1 Resources (Read-Only Data)

| Resource URI                    | Description          | Returns          |
| ------------------------------- | -------------------- | ---------------- |
| `twitter://mentions/{agent_id}` | Recent mentions      | List of tweets   |
| `twitter://trending/{region}`   | Trending topics      | List of trends   |
| `news://{niche}/latest`         | Latest news articles | List of articles |
| `memory://{agent_id}/recent`    | Recent memories      | List of memories |
| `wallet://{agent_id}/balance`   | Wallet balance       | Balance object   |

### 4.2 Tools (Executable Actions)

| Tool Name           | Description              | Input Schema                 |
| ------------------- | ------------------------ | ---------------------------- |
| `generate_text`     | Generate caption/post    | topic, platform, persona_id  |
| `generate_image`    | Generate image           | prompt, style, character_ref |
| `publish_tweet`     | Post to Twitter          | text, media_urls             |
| `publish_instagram` | Post to Instagram        | text, media_urls             |
| `send_transaction`  | Send crypto payment      | to_address, amount, asset    |
| `store_memory`      | Save to long-term memory | content, tags                |
| `search_memory`     | Query memories           | query, limit                 |

### 4.3 Prompts (Reusable Templates)

| Prompt Name         | Description              | Variables         |
| ------------------- | ------------------------ | ----------------- |
| `analyze_sentiment` | Analyze text sentiment   | {text}            |
| `extract_topics`    | Extract key topics       | {text}            |
| `persona_voice`     | Apply persona style      | {text}, {persona} |
| `safety_check`      | Check for unsafe content | {content}         |

## 5. Security Specifications

### 5.1 Authentication

| Component   | Method        | Details              |
| ----------- | ------------- | -------------------- |
| Dashboard   | OAuth 2.0     | Google/GitHub SSO    |
| API         | API Key + JWT | Rotate every 30 days |
| MCP Servers | mTLS          | Certificate-based    |
| Database    | IAM           | Role-based access    |

### 5.2 Secrets Management

| Secret Type          | Storage           | Rotation                 |
| -------------------- | ----------------- | ------------------------ |
| API Keys             | HashiCorp Vault   | 30 days                  |
| Wallet Private Keys  | Vault (encrypted) | Never (derive from seed) |
| Database Credentials | Vault             | 7 days                   |
| JWT Signing Keys     | Vault             | 90 days                  |

### 5.3 Data Classification

| Level            | Examples              | Handling           |
| ---------------- | --------------------- | ------------------ |
| **Public**       | Published posts       | No restrictions    |
| **Internal**     | Campaign configs      | Encrypted at rest  |
| **Confidential** | Wallet keys, API keys | Vault + encryption |
| **Restricted**   | User PII              | Vault + audit log  |

---

## 6. Performance Requirements

### 6.1 Latency Targets

| Operation         | P50   | P95   | P99 |
| ----------------- | ----- | ----- | --- |
| Trend fetch       | 500ms | 1s    | 2s  |
| Text generation   | 2s    | 5s    | 10s |
| Image generation  | 10s   | 30s   | 60s |
| Publish post      | 1s    | 3s    | 5s  |
| HITL notification | 100ms | 500ms | 1s  |

### 6.2 Throughput Targets

| Metric              | Target | Burst |
| ------------------- | ------ | ----- |
| Tasks/second        | 100    | 500   |
| Publications/minute | 60     | 120   |
| API requests/second | 1000   | 5000  |

### 6.3 Resource Limits

| Resource               | Limit    | Action on Exceed   |
| ---------------------- | -------- | ------------------ |
| Daily budget per agent | $50 USDC | Block transactions |
| Task queue depth       | 10,000   | Reject new tasks   |
| HITL queue age         | 4 hours  | Auto-reject        |
| Memory per agent       | 100MB    | Prune old memories |

## 7. Monitoring & Observability

### 7.1 Metrics to Collect

| Category        | Metrics                                      |
| --------------- | -------------------------------------------- |
| **System**      | CPU, Memory, Disk, Network                   |
| **Application** | Request rate, Error rate, Latency            |
| **Business**    | Publications/day, Engagement rate, HITL rate |
| **Cost**        | API spend, Inference cost, Gas fees          |

### 7.2 Alerts

| Alert              | Condition             | Severity |
| ------------------ | --------------------- | -------- |
| High error rate    | > 5% errors in 5 min  | Critical |
| HITL queue backlog | > 100 items pending   | Warning  |
| Budget threshold   | > 80% daily budget    | Warning  |
| Agent down         | No heartbeat in 5 min | Critical |

---

## 8. Deployment Configuration

### 8.1 Environment Variables

```bash
# Required
GEMINI_API_KEY=xxx
ANTHROPIC_API_KEY=xxx
REDIS_URL=redis://localhost:6379
DATABASE_URL=postgresql://user:pass@localhost/chimera

# Optional
LOG_LEVEL=INFO
ENVIRONMENT=development
MAX_WORKERS=10
HITL_TIMEOUT_HOURS=4
```

### 8.2 Docker Compose Services

```yaml
services:
    orchestrator:
        image: chimera/orchestrator:latest
        ports:
            - "8000:8000"
        depends_on:
            - redis
            - postgres

    worker:
        image: chimera/worker:latest
        deploy:
            replicas: 5
        depends_on:
            - redis

    judge:
        image: chimera/judge:latest
        depends_on:
            - redis

    redis:
        image: redis:7-alpine
        ports:
            - "6379:6379"

    postgres:
        image: timescale/timescaledb:latest-pg15
        ports:
            - "5432:5432"
        environment:
            POSTGRES_DB: chimera
            POSTGRES_USER: chimera
            POSTGRES_PASSWORD: ${DB_PASSWORD}
```
