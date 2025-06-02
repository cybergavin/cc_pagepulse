# 🚀 Confluence Cloud PagePulse

**Confluence Cloud PagePulse** is a secure, containerized web application that evaluates the quality of Confluence pages using a configurable AI model (e.g., GPT-4o). It scrapes wiki content from Confluence Cloud and rates it across multiple documentation quality metrics like clarity, accuracy, relevance, actionability, and consistency, returning actionable feedback.

Built for internal documentation auditing, this tool empowers technical writers, product owners, and engineering teams to maintain high standards across your organization's wiki content.

---

## 📦 Features

* ✅ **Secure distroless container image** using [Chainguard's Wolfi base](https://github.com/chainguard-dev).
* 🧠 **LLM-powered evaluation** using customizable OpenAI-compatible LLM providers/models.
* 🔒 **Token-based access** to Confluence and LLM endpoints via `.env`.
* 📈 **Customizable quality criteria** for precise, actionable feedback.
* 🧰 **Cache layer (SQLite)** to minimize repeated LLM requests and optimize API usage.
* ⚡ **FastAPI** backend for scalable web integration.

---

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

---

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

[cache]
database = "cc_pagepulse_cache.db"
ttl_seconds = 2592000
```

> 🔍 Prompts for document evaluation are defined in the `[prompts]` section of this file and are fully customizable.

---

## 🐳 Running via Docker

### Pre-requisites

* Ensure you have:

  * A valid `.env` file with API credentials.
  * A valid `config.toml` file.
  * A local directory called `cache` for cache persistence with full permissions for the container.

### Run Command

```bash
docker run --rm -it \
  -v $(pwd)/config.toml:/app/config.toml \
  -v $(pwd)/.env:/app/.env \
  -v $(pwd)/cache:/app/cache \
  -p 8000:8000 \
  cc_pagepulse
```

> 🛡️ The image is based on Chainguard’s minimal, secure Python base image and is compiled with `uv` for fast, reproducible dependency resolution.

---

## 🌐 Web Interface

Once running, open your browser to:
**[http://localhost:8000](http://localhost:8000)**

Submit a Confluence page URL to receive an AI-generated quality rating and actionable feedback.

---

## 🔐 Security Notes

* Container built from **Wolfi (distroless)** base for minimal attack surface.
* No OS package manager or shell in production image.
* Sensitive tokens are injected at runtime via `.env`.

---

## 🔄 Caching

* Scraped content and AI responses are cached in a local SQLite DB (`cache/cc_pagepulse_cache.db`) with a configurable TTL.
* Helps reduce cost and API usage for repeat evaluations.

---

## 🧰 Development

### Install with `uv`

To run locally (Python 3.11+):

```bash
uv venv
source .venv/bin/activate
uv pip install -e .
```

Then start the server:

```bash
python cc_pagepulse_api.py
```

## 🙋 FAQ

**Q:** Does this work with Confluence Server?
**A:** No, currently only Confluence Cloud is supported (via its REST API).

**Q:** Can I use a different LLM provider?
**A:** Yes, as long as the provider supports OpenAI-compatible APIs.

**Q:** Can I change the evaluation criteria?
**A:** Absolutely. Modify the `user_page_rating` prompt in `config.toml`.

