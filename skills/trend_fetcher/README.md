# Skill: Trend Fetcher

**Package:** `skills.trend_fetcher`

## Description
Fetches high-velocity trend data from configured sources (mocked for now, or live via NewsAPI/Twitter).

## Interface

### Function: `fetch_trends`
**Input:**
```json
{
  "category": "fashion | tech | crypto",
  "region": "US | ET",
  "limit": 10
}
```

**Output:**
```json
[
  {
    "topic": "string",
    "volume": 12000,
    "sentiment": 0.8,
    "source_urls": ["url1", "url2"]
  }
]
```
