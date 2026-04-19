# /ingest

Process all unprocessed files in `wiki/raw/` into structured wiki pages.

## Your role

You are the LLM brain of this pipeline. `scripts/wiki/render.py` is the Jinja2 renderer — it is dumb. You do the thinking; the script does the formatting.

## Rules

- Do not write any wiki page without first rendering it through `render.py`.
- Extract only what is in the raw source. Do not add ideas not present there.
- Use `[[WikiLink]]` syntax for all internal references.
- All dates in `DD-MM-YYYY` format.
- Only reference slugs that exist in `wiki/index.md`. Do not invent slugs.
- If a page with the same slug already exists, skip it and note the skip in the log.

## Steps

### 1. Orient

List and read every `.md.j2` file in `scripts/wiki/templates/` — these define exactly which variables each page type requires.

Then read:

- `wiki/schema.md`
- `wiki/index.md`

### 2. Find unprocessed raw files

If `wiki/raw/` does not exist, stop and tell the user to create it and drop files there.

List all `.md` files in `wiki/raw/`. A file is **unprocessed** if its filename does not appear anywhere in `wiki/log.md` (or if `wiki/log.md` does not exist yet).

Stop and tell the user if there is nothing to process.

### 3. For each unprocessed raw file

**a.** Read the raw file.

**b.** Find cross-reference context: scan `wiki/index.md` for slugs whose one-line descriptions overlap with this file's topic. Read those pages (cap at 5).

**c.** Classify: decide which page type(s) this file should produce. One raw file can produce multiple pages of different types.

**d.** For each page to create:

1. Look up which variables the template requires (from what you read in Step 1).
1. Build a JSON object with every required variable filled from the raw content.
1. Create the output directory if it does not exist:

```bash
mkdir -p wiki/<folder>/
```

1. Render through `render.py` and write the file:

```bash
python scripts/wiki/render.py --type <type> << 'EOF' > wiki/<folder>/<slug>.md
{ ...json... }
EOF
```

Type-to-folder mapping:

| type | folder |
| --- | --- |
| `feature` | `features` |
| `choice` | `choices` |
| `knowledge` | `knowledge` |
| `persona` | `personas` |
| `task` | `tasks` |

Example:

```bash
mkdir -p wiki/features/
python scripts/wiki/render.py --type feature << 'EOF' > wiki/features/reply-scoring.md
{
  "title": "Reply Scoring",
  "status": "idea",
  "created": "19-04-2026",
  "updated": "19-04-2026",
  "related": ["power-user"],
  "problem": "Users don't know which reply to send in [[power-user]] situations.",
  "solution": "Score candidate replies by predicted outcome.",
  "open_questions": ["How many candidates to generate?"]
}
EOF
```

### 4. Update `wiki/index.md`

Re-read `wiki/index.md`. Add one line per new page under the correct type heading, in alphabetical order by slug:

```text
- [[slug]] — one-line description
```

Create the heading if it does not exist yet.

### 5. Append to `wiki/log.md`

```markdown
## DD-MM-YYYY — ingest

**Source**: <raw filename(s)>
**Pages created**: [[slug-1]], [[slug-2]]
**Pages skipped**: [[slug-x]] (already exists)
**Pages updated**: (none)
**Pages deleted**: (none)
**Notes**: <anything notable>
```

Create `wiki/log.md` with a `# Log` heading if it does not exist yet.
