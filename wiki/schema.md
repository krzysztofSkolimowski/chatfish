---
title: Wiki Schema
---

# Wiki Schema

The authoritative constitution for the Chatfish wiki. Every ingest, compile, and clean operation reads this file first.

---

## Directory Layout

Directories marked *(exists)* are already on disk. All others are created on first use by the pipeline.

```text
wiki/
├── schema.md       # this file
├── index.md        # content catalog, one line per page, grouped by type
├── log.md          # append-only operation log (newest entry last)
├── raw/            # immutable verbatim source dumps — never edited
├── features/       # product features and ideas
├── choices/        # design and architectural choices
├── knowledge/      # knowledge base — concepts, talks, architecture, references
├── personas/       # user types and stakeholders
├── tasks/          # actionable work items, output of compile workflow
└── mockups/        # index of UI/Figma/HTML prototypes — hand-written, links to external files (exists)
```

Existing `wiki/docs/` content migrates to `wiki/knowledge/` on next ingest or manual move.

Everything in the wiki is maintained by AI. Templates live at `scripts/wiki/templates/<type>.md.j2`.

---

## Page Types

Structure and frontmatter for each type are defined in `scripts/wiki/templates/<type>.md.j2` — that is the source of truth. This table describes purpose only.

| Type      | Folder       | Purpose                                                                  |
| --------- | ------------ | ------------------------------------------------------------------------ |
| `feature` | `features/`  | A product capability, from rough idea to shipped                         |
| `choice`  | `choices/`   | A design or architectural call — why we went this way and what it costs  |
| `knowledge` | `knowledge/` | Anything we know — concepts, talks, architecture, external references  |
| `persona` | `personas/`  | A user type or stakeholder whose goals shape Chatfish                    |
| `task`    | `tasks/`     | An actionable work item, output of compile                               |

---

## Cross-Referencing

Use Obsidian `[[WikiLink]]` syntax throughout page bodies. The slug is the filename without `.md`.

- Good: `[[reply-scoring]]`, `[[power-user]]`
- Bad: `[reply scoring](../features/reply-scoring.md)`

When writing a page that connects to an existing page, add the cross-reference in both directions.

---

## `index.md` Convention

One line per page, grouped by type, alphabetical within group:

```markdown
## Features
- [[reply-scoring]] — Score candidate replies by predicted outcome

## Choices
- [[llm-provider]] — Why we chose Anthropic over OpenAI for scoring

## Knowledge
- [[karpathy-wiki-pattern]] — LLM-maintained wiki as a compounding artifact

## Personas
- [[power-user]] — Heavy Telegram user optimising for social outcomes

## Tasks
- [[build-upload-endpoint]] — Implement POST /conversations/:id/messages
```

After every operation, add new pages and remove deleted ones.

---

## `log.md` Convention

Append-only. Newest entry at the **bottom**:

```markdown
## DD-MM-YYYY — <ingest | compile | clean>

**Source**: <one-line description of input or trigger>
**Pages created**: [[slug-1]], [[slug-2]]
**Pages updated**: [[slug-3]]
**Pages deleted**: (none)
**Notes**: <anything surprising or worth flagging>
```

---

## `raw/` Convention

`raw/` is the **drop zone**. You place files here; ingest reads from them. Files are named `DD-MM-YYYY-<slug>.md` and never edited after creation — they are the immutable record of what was ingested.

---

## Workflows

### Ingest — file raw input, minimal creativity

Goal: take files from `raw/`, classify them, put the content in the right place. No synthesis, no invention.

1. Read all unprocessed files in `raw/` (files not yet referenced in `log.md`)
2. Read `schema.md` + `index.md` + the 3–5 most relevant existing pages
3. Classify each raw file: which page types does it map to?
4. For each page: load template, fill fields from the raw text, write file — do not add ideas not in the source
5. Update `index.md`, append to `log.md` (mark raw files as processed)

---

### Compile — synthesise knowledge into tasks

Goal: read what we know, think, and produce concrete actionable tasks.

1. Read `schema.md` + `index.md` + all relevant pages the user points to (or all open features/choices)
2. Identify gaps, next steps, and open questions worth acting on
3. For each task worth creating: write a `task` page with clear acceptance criteria
4. Update `index.md`, append to `log.md`

This step is allowed to be creative and make connections across pages.

---

### Clean — flag problems, never act unilaterally

Goal: find orphans, broken refs, stale pages, duplicates. Report only.

1. Read all wiki pages + `index.md` + `log.md`
2. Flag pages meeting any criterion:
   - **Orphan** — no `[[WikiLink]]` pointing to it from any other page
   - **Stale** — `status: dropped` with no pages linking to it, or `status: revisit` with no update since the last compile
   - **Duplicate** — content overlaps >80% with another page
   - **Broken ref** — `[[WikiLink]]` targets a file that does not exist
3. Output a clean report — one proposed action per flagged page (delete / merge / fix ref)
4. **Does not act** — waits for explicit approval
5. After approval: execute, update `index.md`, append to `log.md`

---

## Naming Conventions

- Slugs: `kebab-case`, descriptive, no dates
- Raw files: `DD-MM-YYYY-<slug>.md` (date prefix intentional)
- Template files: `scripts/wiki/templates/<type>.md.j2`
- No emoji in filenames or slugs
