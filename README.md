# 🚀 Confluence Cloud PagePulse

**Confluence Cloud PagePulse**  is a secure, containerized web application designed to assess the quality of Confluence pages using an **OpenAI API-compatible AI model provider** (e.g., OpenAI, LiteLLM, OpenRouter). It scrapes wiki content from Confluence Cloud, evaluates it against multiple documentation quality metrics — such as clarity, accuracy, relevance, actionability, and consistency — and provides actionable feedback.

Built for internal documentation auditing, this tool empowers technical writers, product owners, and engineering teams to maintain high standards across their organization's wiki content.


## 📦 Features

* ✅ **Secure distroless container image** using [Chainguard's Wolfi base](https://github.com/chainguard-dev).
* 🧠 **LLM-powered evaluation** using customizable OpenAI-compatible LLM providers/models.
* 🔒 **Token-based access** to Confluence and LLM endpoints via `.env`.
* 📈 **Customizable quality criteria** for precise, actionable feedback.
* 🧰 **Cache layer (SQLite)** to optimize API cost and performance.
* ⚡ **FastAPI** backend for scalable web integration.


## 📁 Repository Structure

```
├── Dockerfile               # Two-stage build: secure, minimal image using Chainguard Python
├── LICENSE
├── cc_pagepulse.py         # Core logic: Confluence scraping + LLM interaction
├── cc_pagepulse_api.py     # FastAPI server exposing the main API endpoints
├── config.toml.sample      # Sample TOML config with webapp, Confluence, and AI settings
├── .env.sample             # Sample environment variable file (tokens, secrets)
├── pyproject.toml          # Project dependencies (for uv)
├── uv.lock                 # Dependency lockfile for reproducibility
├── templates/
    └── index.html          # Basic web UI for submitting page URLs
```


## ⚙️ Configuration

### 1. `.env` File

Create a `.env` file with your secrets (based on `.env.sample`):

```env
AI_API_KEY="your-api-key"
CONFLUENCE_API_TOKEN="your-confluence-api-token"
```

**NOTE:** Any OpenAI-compatible API endpoint for LLMs will work.


### 2. `config.toml`

Customize the web app, Confluence instance, and LLM model configuration:

```toml
[webapp]
title = "Confluence PagePulse"
host  = "0.0.0.0"
port  = 8000

[confluence]
wiki_url = "https://your-org.atlassian.net/wiki"
username = "svc-account@yourdomain.com"

[ai]
endpoint = "https://aigateway.yourdomain.com"
model = "gpt-4o"
max_tokens = 2000
temperature = 0.1
top_p = 0.1

[prompts]
system_page_rating = "You are a document rating assistant. You have been trained to evaluate content in HTML format based on specific criteria."
user_page_rating = "..."  # Full prompt example is provided in config.toml.sample

[cache]
database = "cc_pagepulse_cache.db"
ttl_seconds = 2592000
```

## 🐳 Running via Docker

### Prerequisites

* Ensure you have:

  * A valid `.env` file with API credentials.
  * A valid `config.toml` file.
  * A local directory called `cache` for cache persistence.
  * Permissions as follows:
  ```
  chmod 644 .env config.toml
  chmod 777 cache
  ```

### Run Command

```bash
docker run --rm -d \
  -v $(pwd)/config.toml:/app/config.toml \
  -v $(pwd)/.env:/app/.env \
  -v $(pwd)/cache:/app/cache \
  -p 8000:8000 \
  ghcr.io/cybergavin/cc_pagepulse:latest
```


## 🌐 Web Interface

Once running, open your browser to:
**[http://localhost:8000](http://localhost:8000)**

Submit a Confluence page URL to receive an AI-generated quality rating and actionable feedback.


## 🔐 Security Notes

* Container built from **Wolfi (distroless)** base for minimal attack surface.
* No OS package manager or shell in production image.
* Sensitive tokens are injected at runtime via `.env`.


## 🔄 Caching

* Scraped content and AI responses are cached in a local SQLite DB (`cache/cc_pagepulse_cache.db`) with a configurable TTL.
* Helps reduce cost and API usage for repeat evaluations.


## 🧰 Development

### Install with `uv`

To run locally (Python 3.11+):

```bash
# Install dependencies
uv sync

# Launch the application
python cc_pagepulse_api.py
```

## 🙋 FAQ

**Q:** Does this work with Confluence Server? <br/>
**A:** No, currently only Confluence Cloud is supported (via its REST API).
<br/><br/>
**Q:** Can I use a different LLM provider?<br/>
**A:** Yes, as long as the provider supports OpenAI-compatible APIs.
<br/><br/>
**Q:** Can I change the evaluation criteria?<br/>
**A:** Absolutely. Modify the `user_page_rating` prompt in `config.toml`.


## Accessing the API Documentation
Once the app is running, you can access the FastAPI interactive docs at http://<host>:8000/docs