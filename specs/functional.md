# Project Chimera - Functional Specification

## 1. Actor Definitions

### 1.1 Primary Actors

| Actor                | Type  | Description                              |
| -------------------- | ----- | ---------------------------------------- |
| **Network Operator** | Human | Manages campaigns, monitors fleet health |
| **HITL Reviewer**    | Human | Reviews and approves escalated content   |
| **Planner Agent**    | AI    | Decomposes goals into executable tasks   |
| **Worker Agent**     | AI    | Executes single atomic tasks             |
| **Judge Agent**      | AI    | Validates output quality and safety      |
| **External Agent**   | AI    | Other agents in OpenClaw network         |

### 1.2 System Actors

| Actor            | Type    | Description                   |
| ---------------- | ------- | ----------------------------- |
| **Orchestrator** | Service | Central control plane         |
| **MCP Server**   | Service | External API bridge           |
| **Task Queue**   | Service | Redis-based task distribution |

## 2. User Stories

### 2.1 Campaign Management

#### US-001: Create Campaign

```
As a Network Operator
I want to create a new campaign with goals and constraints
So that the Planner Agent knows what content to generate
```

**Acceptance Criteria:**

- [ ] Can specify campaign name, duration, and budget
- [ ] Can define target audience demographics
- [ ] Can set content themes and hashtags
- [ ] Campaign is persisted in database
- [ ] Planner Agent receives campaign context

#### US-002: Monitor Fleet Health

```
As a Network Operator
I want to view real-time status of all agents
So that I can identify and resolve issues quickly
```

**Acceptance Criteria:**

- [ ] Dashboard shows agent states (Planning, Working, Judging, Idle)
- [ ] Wallet balances visible for all agents
- [ ] HITL queue depth displayed
- [ ] Error rates and success rates visible

### 2.2 Trend Research

#### US-003: Fetch Trending Topics

```
As a Planner Agent
I need to fetch current trending topics in my niche
So that I can plan relevant content
```

**Acceptance Criteria:**

- [ ] Receives trends from configured sources (Twitter, News, Reddit)
- [ ] Trends include relevance score (0.0-1.0)
- [ ] Trends filtered by agent's niche/persona
- [ ] Results cached for 15 minutes

**API Contract:**

```json
{
    "input": {
        "niche": "string",
        "region": "string",
        "limit": "integer"
    },
    "output": {
        "trends": [
            {
                "topic": "string",
                "score": "float",
                "source": "string",
                "volume": "integer"
            }
        ],
        "fetched_at": "datetime"
    }
}
```

#### US-004: Analyze Trend Sentiment

```
As a Planner Agent
I need to understand the sentiment around a trend
So that I can decide whether to engage
```

**Acceptance Criteria:**

- [ ] Returns sentiment classification (positive, negative, neutral)
- [ ] Includes confidence score
- [ ] Flags controversial topics for HITL

### 2.3 Content Generation

#### US-005: Generate Text Content

```
As a Worker Agent
I need to generate caption/post text for a given topic
So that I can create engaging social content
```

**Acceptance Criteria:**

- [ ] Text matches agent's persona voice
- [ ] Includes relevant hashtags
- [ ] Respects platform character limits
- [ ] Passes profanity/safety filter

**API Contract:**

```json
{
    "input": {
        "topic": "string",
        "platform": "twitter|instagram|tiktok",
        "persona_id": "string",
        "max_length": "integer"
    },
    "output": {
        "text": "string",
        "hashtags": ["string"],
        "confidence": "float",
        "persona_alignment": "float"
    }
}
```

#### US-006: Generate Image Content

```
As a Worker Agent
I need to generate an image for a post
So that I can create visually engaging content
```

**Acceptance Criteria:**

- [ ] Image matches prompt description
- [ ] Character consistency maintained (face/style)
- [ ] Resolution appropriate for platform
- [ ] No copyrighted content

**API Contract:**

```json
{
    "input": {
        "prompt": "string",
        "style": "string",
        "character_ref_id": "string",
        "aspect_ratio": "1:1|4:5|16:9"
    },
    "output": {
        "image_url": "string",
        "width": "integer",
        "height": "integer",
        "generation_id": "string"
    }
}
```

#### US-007: Generate Video Content

```
As a Worker Agent
I need to generate short-form video content
So that I can engage audiences on video platforms
```

**Acceptance Criteria:**

- [ ] Video duration 5-60 seconds
- [ ] Supports image-to-video (Living Portrait)
- [ ] Supports text-to-video (Hero content)
- [ ] Audio track optional

### 2.4 Social Publishing

#### US-008: Publish to Platform

```
As a Worker Agent
I need to publish content to a social platform
So that the audience can see and engage with it
```

**Acceptance Criteria:**

- [ ] Supports Twitter, Instagram, TikTok
- [ ] Includes proper AI disclosure labels
- [ ] Returns post ID and URL
- [ ] Handles rate limiting gracefully

**API Contract:**

```json
{
    "input": {
        "platform": "twitter|instagram|tiktok",
        "content": {
            "text": "string",
            "media_urls": ["string"]
        },
        "schedule_time": "datetime|null"
    },
    "output": {
        "post_id": "string",
        "post_url": "string",
        "published_at": "datetime"
    }
}
```

#### US-009: Reply to Comment

```
As a Worker Agent
I need to generate and post replies to comments
So that I can maintain engagement with the audience
```

**Acceptance Criteria:**

- [ ] Reply relevant to original comment
- [ ] Matches agent persona
- [ ] Avoids inflammatory responses
- [ ] Respects reply rate limits

### 2.5 Quality & Safety

#### US-010: Validate Content Quality

```
As a Judge Agent
I need to validate that generated content meets standards
So that only quality content is published
```

**Acceptance Criteria:**

- [ ] Checks persona alignment score > 0.8
- [ ] Verifies no profanity/hate speech
- [ ] Confirms brand safety compliance
- [ ] Validates image character consistency

#### US-011: Route Based on Confidence

```
As a Judge Agent
I need to route content based on confidence score
So that risky content gets human review
```

**Acceptance Criteria:**

- [ ] confidence > 0.90 → Auto-approve
- [ ] 0.70 ≤ confidence ≤ 0.90 → HITL queue
- [ ] confidence < 0.70 → Reject and retry
- [ ] Sensitive topics → Always HITL

#### US-012: Review Escalated Content

```
As a HITL Reviewer
I want to review flagged content quickly
So that publishing isn't delayed unnecessarily
```

**Acceptance Criteria:**

- [ ] See content preview (text, image, video)
- [ ] See confidence score and reasoning
- [ ] Can Approve, Edit, or Reject
- [ ] Decision logged for training

### 2.6 Agentic Commerce

#### US-013: Check Wallet Balance

```
As a Planner Agent
I need to check my wallet balance
So that I know if I have budget for content generation
```

**Acceptance Criteria:**

- [ ] Returns balance in USDC and ETH
- [ ] Includes pending transactions
- [ ] Alerts if balance below threshold

**API Contract:**

```json
{
    "input": {
        "agent_id": "string"
    },
    "output": {
        "balances": {
            "USDC": "float",
            "ETH": "float"
        },
        "pending": "float",
        "wallet_address": "string"
    }
}
```

#### US-014: Execute Payment

```
As a Worker Agent
I need to send payment for services rendered
So that I can pay for content generation costs
```

**Acceptance Criteria:**

- [ ] Supports USDC transfers on Base
- [ ] Requires CFO Judge approval if > $50
- [ ] Transaction logged on-chain
- [ ] Updates daily spend tracking

### 2.7 OpenClaw Integration

#### US-015: Register with OpenClaw

```
As a Chimera Agent
I want to register my capabilities with OpenClaw
So that other agents can discover and hire me
```

**Acceptance Criteria:**

- [ ] Publishes skill list and pricing
- [ ] Updates availability status
- [ ] Includes reputation score

#### US-016: Accept External Task

```
As a Chimera Agent
I want to accept content creation requests from other agents
So that I can earn revenue
```

**Acceptance Criteria:**

- [ ] Validates requester reputation
- [ ] Checks payment escrow
- [ ] Executes task through normal pipeline
- [ ] Delivers result and collects payment

## 4. Priority Matrix

| User Story                | Priority | Complexity | Sprint |
| ------------------------- | -------- | ---------- | ------ |
| US-003 Fetch Trends       | P0       | Medium     | 1      |
| US-005 Generate Text      | P0       | Medium     | 1      |
| US-008 Publish            | P0       | High       | 1      |
| US-010 Validate Quality   | P0       | Medium     | 1      |
| US-011 Confidence Routing | P0       | Low        | 1      |
| US-006 Generate Image     | P1       | High       | 2      |
| US-009 Reply Comments     | P1       | Medium     | 2      |
| US-013 Check Balance      | P1       | Low        | 2      |
| US-007 Generate Video     | P2       | Very High  | 3      |
| US-015 OpenClaw Register  | P2       | Medium     | 3      |
