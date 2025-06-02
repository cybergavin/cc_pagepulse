########### BUILDER STAGE ###########
FROM cgr.dev/chainguard/python:latest-dev AS builder

ENV UV_COMPILE_BYTECODE=1 \
    UV_LINK_MODE=copy

WORKDIR /app

# Install dependencies using uv with caching
RUN --mount=type=cache,target=/root/.cache/uv \
    --mount=type=bind,source=uv.lock,target=uv.lock \
    --mount=type=bind,source=pyproject.toml,target=pyproject.toml \
    uv sync --frozen --no-install-project --no-dev

########### FINAL STAGE ###########
FROM cgr.dev/chainguard/python:latest

WORKDIR /app

# Ensure logs are flushed immediately
ENV PYTHONUNBUFFERED=1

# Copy virtual environment
COPY --from=builder /app/.venv /venv/

# Copy application files 
COPY cc_pagepulse*.py /app/
COPY templates /app/templates/

# Use the virtual environment’s Python to run the application
ENTRYPOINT [ "/venv/bin/python", "cc_pagepulse_api.py" ]