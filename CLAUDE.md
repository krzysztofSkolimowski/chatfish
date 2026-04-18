# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

**Chatfish** is a Go application that reads Telegram conversations, generates reply suggestions, and scores them — like "Stockfish for chat". A browser extension captures conversation data, posts it to a Go backend, which builds context and calls an LLM to rank candidate replies.

The `site/` directory uses [Quartz v4](https://quartz.jzhao.xyz/) to publish a wiki and mockups to GitHub Pages. The wiki follows the [Karpathy LLM Wiki pattern](https://gist.github.com/karpathy/442a6bf555914893e9891c11519de94f) — raw sources are fed to an LLM pipeline that maintains interconnected Markdown pages in `wiki/`.

## Repository Structure

```
chatfish/
├── .github/workflows/
│   ├── backend-ci.yml     # calls scripts/backend-*.sh — triggers on backend/**, scripts/**
│   ├── pages.yml          # Quartz build + GitHub Pages deploy — triggers on site/**, wiki/**
│   └── site-sanity.yml    # calls scripts/site-test.sh — triggers on site/**, wiki/**
├── backend/               # Go application
│   ├── Dockerfile
│   ├── go.mod
│   └── main.go
├── scripts/               # Shared scripts (local + CI). Output → scripts/out/ (gitignored)
│   ├── backend-test.sh
│   ├── backend-vet.sh
│   ├── docker-build.sh
│   ├── site-build.sh
│   ├── site-test.sh
│   ├── trigger-ci.sh      # gh workflow run <workflow>
│   └── ci-status.sh       # gh run list
├── wiki/                  # Obsidian vault — all wiki/docs/mockup content (Markdown + assets)
│   ├── index.md
│   ├── docs/
│   └── mockups/
└── site/                  # Quartz v4 — GitHub Pages publisher (do not add content here)
    ├── quartz.config.ts   # Quartz configuration (baseUrl, theme, plugins)
    ├── quartz.layout.ts   # Page layout components
    ├── quartz/            # Quartz framework source (do not edit)
    ├── tests/             # Playwright smoke tests
    │   └── sanity.spec.js
    ├── playwright.config.js
    └── package.json
```

## Scripts (source of truth — used locally and in CI)

All scripts live in `scripts/`, write output to `scripts/out/<name>.txt` via `tee`, and exit non-zero on failure. **Always run a script rather than constructing ad-hoc shell commands.** After running, read `scripts/out/<name>.txt` to review results.

| Script | What it does |
|---|---|
| `scripts/backend-test.sh` | `go test -race ./...` |
| `scripts/backend-vet.sh` | `go vet` + `gofmt` check |
| `scripts/docker-build.sh` | `docker build -t chatfish ./backend` |
| `scripts/site-build.sh` | `npm install` + `quartz build` |
| `scripts/site-test.sh` | Build + serve + Playwright smoke tests |
| `scripts/trigger-ci.sh [backend\|pages\|site-sanity]` | Trigger a GitHub Actions workflow via `gh` |
| `scripts/ci-status.sh [workflow]` | List recent CI runs via `gh` |

### One-off commands not covered by scripts
```bash
cd backend && go run .                        # Run dev server on :8080
cd backend && gofmt -w .                      # Auto-format (fix, not check)
docker run -p 8080:8080 chatfish             # Run built image
curl localhost:8080/ping                      # Health check
cd site && npx quartz build -d ../wiki --serve  # Quartz dev server
```

## Automation

**Claude Code hooks** (`.claude/settings.json`):
- After every `Edit`/`Write` on a `backend/` file → runs `go vet` immediately
- After every `Edit`/`Write` on a `site/` file (excluding `public/`) → prompts Claude to verify with Playwright MCP before finishing

**GitHub Actions**:
- `backend/**` push → `backend-ci.yml`: test, vet, format check, docker build
- `site/**` or `wiki/**` push → `pages.yml`: Quartz build + deploy to GitHub Pages
- `site/**` or `wiki/**` push → `site-sanity.yml`: Quartz build + Playwright smoke tests

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
