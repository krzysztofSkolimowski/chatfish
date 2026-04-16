# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

**Chatfish** is a Go application that reads Telegram conversations, generates reply suggestions, and scores them — like "Stockfish for chat". A browser extension captures conversation data, posts it to a Go backend, which builds context and calls an LLM to rank candidate replies.

## Repository Structure

```
chatfish/
├── .github/workflows/
│   ├── backend-ci.yml     # Go: test, vet, docker  — triggers on backend/**
│   ├── pages-deploy.yml   # Hugo build + GitHub Pages deploy — triggers on site/**
│   └── site-sanity.yml    # Playwright smoke tests — triggers on site/**
├── backend/               # Go application
│   ├── Dockerfile
│   ├── go.mod
│   └── main.go
└── site/                  # Hugo — GitHub Pages (docs, mockups)
    ├── content/
    ├── tests/             # Playwright smoke tests
    │   └── sanity.spec.js
    ├── playwright.config.js
    ├── package.json
    └── hugo.toml
```

## Commands

### Backend (Go)
```bash
cd backend
go run .                   # Run locally (HTTP server on :8080)
go build -o chatfish .     # Build binary
go test -race ./...        # Run all tests (matches CI)
go vet ./...               # Vet
gofmt -l .                 # Check formatting (CI fails on unformatted files)
gofmt -w .                 # Auto-format
```

```bash
docker build -t chatfish ./backend
docker run -p 8080:8080 chatfish
curl localhost:8080/ping   # Health check
```

### Site (Hugo + Playwright)
```bash
cd site
hugo server                # Dev server at http://localhost:1313
hugo --minify              # Build to site/public/

npm install                # Install Playwright (first time)
npx playwright test        # Run smoke tests (starts Hugo server automatically)
```

## Automation

**Claude Code hooks** (`.claude/settings.json`):
- After every `Edit`/`Write` on a `backend/` file → runs `go vet` immediately
- After every `Edit`/`Write` on a `site/` file (excluding `public/`) → prompts Claude to verify with Playwright MCP before finishing

**GitHub Actions**:
- `backend/**` push → `backend-ci.yml`: test, vet, format check, docker build
- `site/**` push → `pages-deploy.yml`: Hugo build + deploy to GitHub Pages
- `site/**` push → `site-sanity.yml`: Hugo build + Playwright smoke tests

## Architecture

The planned system has four services inside the Go backend, fed by a browser extension and calling an external LLM:

| Service | Responsibility |
|---|---|
| `api` | HTTP layer — routes requests to upload and scoring |
| `upload` | Receive messages from client, persist to store |
| `store` | PostgreSQL conversation history, provides context window |
| `scoring` | Build prompt from context, call LLM, rank candidates |

**Data flow**: Browser Extension → `POST /conversations/:id/messages` → upload → store → `POST /conversations/:id/suggest` → context builder (fetches last N messages) → scoring → LLM → ranked suggestions → extension.

**Stack**: Go backend, PostgreSQL (conversation history), Redis (session/context cache), LLM API (OpenAI / Anthropic / Ollama), Docker deployment.

## Current State

The project is in early development. `backend/main.go` has an HTTP server with a `/ping` endpoint. The service packages (`upload`, `store`, `scoring`) are not yet implemented.
