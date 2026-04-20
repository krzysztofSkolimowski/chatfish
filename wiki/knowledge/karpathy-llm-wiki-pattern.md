---
title: LLM Wiki Pattern
type: knowledge
source: https://gist.github.com/karpathy/442a6bf555914893e9891c11519de94f
created: 19-04-2026
related: []
---

# LLM Wiki Pattern

## Summary

A pattern for building personal knowledge bases using LLMs. Instead of RAG (retrieving from raw docs at query time), the LLM incrementally builds and maintains a persistent wiki — structured, interlinked markdown files. Knowledge is compiled once and kept current, compounding with every source added. Three layers: raw sources (immutable), wiki (LLM-owned markdown), schema (config doc like CLAUDE.md).

## Key Points

1. The wiki is a persistent, compounding artifact — not re-derived per query like RAG
2. Three layers: raw sources (immutable), wiki (LLM-maintained markdown), schema (config/CLAUDE.md that defines conventions)
3. Operations: Ingest (file raw source into wiki), Query (answer from wiki), Lint (health-check for contradictions, orphans, stale pages)
4. index.md is a content-oriented catalog; log.md is a chronological append-only record
5. LLMs handle all bookkeeping (cross-refs, summaries, consistency); humans handle curation and questions
6. Good query answers can be filed back into the wiki as new pages — explorations compound just like ingested sources

## Relevance to Chatfish

Chatfish uses this exact pattern for its wiki. The schema, index, log, and ingest workflow in wiki/ all implement this pattern directly. Raw sources go in wiki/raw/, the LLM maintains wiki/, and wiki/schema.md is the constitution.

## Open Questions

- (none yet)

## Related

(none)

