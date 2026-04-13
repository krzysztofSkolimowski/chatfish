# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

**Chatfish** is a Go application that reads Telegram conversations, generates reply suggestions, and scores them — like "Stockfish for chat". A browser extension captures conversation data, posts it to a Go backend, which builds context and calls an LLM to rank candidate replies.

## Commands

```bash
go run .             # Run locally (HTTP server on :8080)
go build -o chatfish . # Build binary
go test -race ./...  # Run all tests (matches CI)
go vet ./...         # Vet
gofmt -l .           # Check formatting (CI fails on unformatted files)
gofmt -w .           # Auto-format
```

```bash
docker build -t chatfish .
docker run -p 8080:8080 chatfish
curl localhost:8080/ping  # Health check
```

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

The project is in early development. `main.go` currently only has an HTTP server with a `/ping` endpoint. The service packages (`upload`, `store`, `scoring`) are not yet implemented.
