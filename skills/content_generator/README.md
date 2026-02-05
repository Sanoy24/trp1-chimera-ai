# Skill: Content Generator

**Package:** `skills.content_generator`

## Description
Generates multimodal content (Text, Image) using LLM and Image Gen providers.

## Interface

### Function: `generate_post`
**Input:**
```json
{
  "platform": "twitter | instagram",
  "prompt": "string",
  "style_preset": "cyberpunk_v2"
}
```

**Output:**
```json
{
  "text_content": "string",
  "image_url": "string (optional)",
  "metadata": {
    "model_used": "gemini-pro",
    "generation_time": 1.2
  }
}
```
