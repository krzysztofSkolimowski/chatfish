# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

**Chatfish** is a Go application that reads Telegram conversations, generates reply suggestions, and scores them — like "Stockfish for chat". A browser extension captures conversation data, posts it to a Go backend, which builds context and calls an LLM to rank candidate replies.

The `site/` directory uses [Quartz v4](https://quartz.jzhao.xyz/) to publish a wiki and mockups to GitHub Pages. The wiki follows the [Karpathy LLM Wiki pattern](https://gist.github.com/karpathy/442a6bf555914893e9891c11519de94f) — raw sources are fed to an LLM pipeline that maintains interconnected Markdown pages in `wiki/`.

## Repository Structure

```
chatfish/
├── .github/workflows/
│   ├── backend-ci.yml     # calls scripts/ci/backend-*.sh — triggers on backend/**, scripts/ci/**
│   ├── pages.yml          # calls scripts/ci/site-build.sh — triggers on site/**, wiki/**
│   └── site-sanity.yml    # calls scripts/ci/site-test.sh — triggers on site/**, wiki/**
├── backend/               # Go application
│   ├── Dockerfile
│   ├── go.mod
│   └── main.go
├── scripts/
│   ├── _lib.sh            # sourced by all scripts — sets REPO, tees output locally
│   ├── ci/                # called directly from GitHub Actions
│   │   ├── backend-test.sh
│   │   ├── backend-vet.sh
│   │   ├── backend-lint.sh
│   │   ├── site-build.sh
│   │   ├── site-test.sh
│   │   └── docker-build.sh
│   ├── dev/               # local developer tools
│   │   ├── run-ci.sh      # run all ci/ scripts locally
│   │   └── ci-status.sh   # fetch job results for HEAD commit via gh
│   └── out/               # gitignored — output files written by scripts
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

**Never construct ad-hoc shell commands.** Always use a script. CI scripts write output to `scripts/out/<name>.txt`; read that file to review results.

### After finishing any work

1. Run `bash scripts/dev/run-ci.sh` — executes all `ci/` scripts locally and writes an executive summary to `scripts/out/run-ci.txt`. Read that file first.
2. If anything failed, the summary contains `FAIL <script> → scripts/out/<script>.txt`. Read that file for the full output.
3. After pushing, wait for CI then run `bash scripts/dev/ci-status.sh` — fetches job-level results for HEAD from GitHub. On failure it includes the failed job logs inline. Read `scripts/out/ci-status.txt`.

### CI scripts (`scripts/ci/`) — also called from GitHub Actions

| Script | What it does |
|---|---|
| `scripts/ci/backend-test.sh` | `go test -race ./...` |
| `scripts/ci/backend-vet.sh` | `go vet` + `gofmt` check |
| `scripts/ci/backend-lint.sh` | `golangci-lint run` |
| `scripts/ci/site-build.sh` | `npm ci` + `quartz build` |
| `scripts/ci/site-test.sh` | Build + serve + Playwright smoke tests |
| `scripts/ci/docker-build.sh` | `docker build -t chatfish ./backend` |

### Dev scripts (`scripts/dev/`) — local only

| Script | What it does |
|---|---|
| `scripts/dev/run-ci.sh` | Run all `ci/` scripts; write pass/fail index to `scripts/out/run-ci.txt` |
| `scripts/dev/ci-status.sh` | Fetch job results for HEAD commit via `gh`; include failed logs inline |

### Hook scripts (`scripts/hooks/`) — invoked by Claude Code hooks

| Script | Hook | What it does |
|---|---|---|
| `scripts/hooks/post-edit-backend-vet.sh` | PostToolUse Edit\|Write | Run `backend-vet.sh` when a `backend/` file is edited |
| `scripts/hooks/post-edit-site-check.sh` | PostToolUse Edit\|Write | Remind Claude to Playwright-verify when a `site/` file is edited |
| `scripts/hooks/pre-bash-block-destructive.sh` | PreToolUse Bash | Block destructive commands (`rm -rf`, force-push, hard-reset, DDL drops) |
| `scripts/hooks/pre-bash-ci-before-commit.sh` | PreToolUse Bash | Run full CI before any `git commit`; block on failure |
| `scripts/hooks/stop-run-ci.sh` | Stop | Run full CI after Claude finishes each turn |

### One-off commands not covered by scripts
```bash
cd backend && go run .                           # Run dev server on :8080
cd backend && gofmt -w .                         # Auto-format (fix, not check)
docker run -p 8080:8080 chatfish                # Run built image
curl localhost:8080/ping                         # Health check
cd site && npx quartz build -d ../wiki --serve   # Quartz dev server
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
