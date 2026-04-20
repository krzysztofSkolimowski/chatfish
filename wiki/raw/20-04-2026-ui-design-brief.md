# Chatfish — UI Design Brief

**Purpose**: Instructions for Claude Design (or any design tool) to generate mockups of the Chatfish application.

---

## Product Concept

**Chatfish** is a "conversation couch" — an AI-powered social interaction assistant inspired by how chess.com shows Stockfish evaluation. Just as Stockfish scores a chess position and suggests the best move, Chatfish scores a conversation and surfaces the best reply.

The product helps users become more effective in social interactions: flirting, dating, networking, negotiation. Think of it as an **AI wingman** that lives inside your messaging apps.

---

## Core Metaphor: The Evaluation Bar

The central UI element is a vertical score bar — a direct analogue to the Stockfish evaluation bar in chess:

- **Red (Fiery)(positive)**: the conversation is going well for the user — the other person is engaged, reciprocating, leaning in
- **Blue (Icy) (negative)**: the conversation is losing momentum — the user is chasing, over-investing, or the other person is pulling back
- **neutral at centre**: balanced, neutral state

(score goes from +10 to -10)

The bar animates smoothly as new messages arrive. It is the emotional heartbeat of the UI — always visible, immediately legible.

Each message is getting scored in real time. Chatfish also provides 3-5 ranked reply suggestions. 

Score of the message is based on it's impact of the main score - e.g. - message gives you +0.5 points (like each subsequent move in chess) 

---

## Components to Design

### 1. Chat Plugin Overlay (Primary surface)

**Platforms**: Telegram Web, WhatsApp Web (browser extension injects this UI)

A sidebar panel that attaches to the left edge of the existing chat window. It does **not** replace the chat — it overlays alongside it. The native chat remains fully usable.

**Sidebar contents (top to bottom)**:

**Score bar** (left edge of sidebar, full height)
- Vertical evaluation bar, chess.com style
- Colour: green (positive) → grey (neutral) → red (negative)
- Numerical score shown next to bar (e.g. +1.4, −0.8)
- Label: "Conversation Score"

**Reply Suggestions panel** (main body of sidebar)
- Heading: "Top Replies"
- 3–5 candidate replies, each as a card:
  - Reply text (1–3 sentences)
  - Quality badge: star rating or letter grade (A / B / C)
  - Predicted outcome tag: e.g. "builds rapport", "creates mystery", "escalates", "re-engages"
  - "Use this" button — copies reply to clipboard or injects into the compose box
- Cards are ranked: best reply at the top
- Each card subtly colour-coded by predicted tone (warm / neutral / playful / bold)

**Context strip** (bottom of sidebar)
- Small pill showing interlocutor name + profile thumbnail
- Last 2–3 analysed messages (collapsed, expandable)
- "Refresh analysis" button

**Collapse toggle**: a small tab on the left edge of the sidebar — clicking collapses the sidebar to a thin strip showing only the score bar and a ⚡ icon.

---

### 2. Native Chat (Standalone App Surface)

Chatfish also has its own native chat interface for practising conversations or replaying past ones without being inside Telegram/WhatsApp.

Layout: a standard two-column chat app shell:
- **Left column**: conversation list (past conversations, contacts, practice sessions)
- **Right column**: active conversation with the same sidebar overlay as the plugin — score bar + reply suggestions — but integrated natively into the layout rather than injected

At the top of the right column: a mode switcher
- "Live" (connected to real Telegram conversation via API)
- "Practice" (simulated conversation with AI playing the other person)
- "Replay" (review a past conversation with post-hoc scoring)

---

### 3. Control Panel / Settings

A dedicated settings screen accessible from a gear icon in the sidebar or native app header.

**Sections**:

**Profile** — the user's own profile
- Name, photo, short bio (used to personalise suggestions)
- "My goals": dropdown — Flirting / Dating / Networking / Negotiation / Friendship
- Communication style preference: Direct / Playful / Reserved / Bold

**Connections** — linked messaging accounts
- List of connected accounts: Telegram, WhatsApp (with connect/disconnect buttons)
- Privacy note: "Chatfish reads only conversations you open the plugin in"

**AI Model** — scoring engine settings
- Model selector: Fast (lower latency) / Deep (higher quality)
- Suggestion count: 3 / 5 / 7
- Language: auto-detect / manual

**Appearance**
- Theme: Light / Dark / System
- Sidebar position: Right / Left
- Score bar: always visible / collapsed by default

**Privacy & Data**
- Toggle: "Store conversation history" (on/off)
- "Delete all stored data" (destructive, requires confirmation)
- Link to privacy policy

---

### 4. Interlocutor Profile & AI Insights (Separate Design)

Each person the user chats with gets an AI-generated profile built from their conversation history.

This is a **separate screen** — accessible by clicking the interlocutor's name/avatar in the sidebar or native chat.

**Profile card header**
- Name, avatar, platform (Telegram / WhatsApp)
- First contact date, total messages analysed

**Conversation Goals** — user-defined intent for this specific person
- Goal selector: Flirt / Date / Casual / Relationship / Friendship / Networking
- Free-text "notes to self" field (e.g. "she mentioned she likes hiking, bring it up naturally")
- Tone preference override for this person: Playful / Mysterious / Direct / Romantic
- These goals feed directly into the scoring engine and reply suggestions — the AI tailors its output to the stated intent

**AI Insights panel** — the core of this screen
Generated personality and communication analysis, displayed as labelled metrics and short text summaries:

- **Communication style**: e.g. "Direct and assertive — responds well to confidence, dislikes hedging"
- **Engagement pattern**: graph of response times and message lengths over time
- **Interest indicators**: e.g. "Initiates topics: travel, music, career" — shown as tags
- **Reciprocity score**: how balanced is the conversation effort (0–100 bar)
- **Attachment signals**: e.g. "Uses humour defensively — softens with emojis when uncertain"
- **Recommended approach**: 2–3 bullet points — what works with this person specifically

**Conversation timeline**
- Scrollable list of key moments: "First compliment received", "First plan suggestion", "First response delay > 12h"
- Each moment is a small card with date + excerpt + significance note

**Score trend chart**
- Line chart of conversation score over time (by day or by session)
- Annotations at notable spikes/drops

---

## Visual Style

- **Aesthetic**: warm, sensual, and playful — closer to Tinder or Hinge than chess.com or Linear. The app should feel alive and human, not cold or analytical. Premium dating app energy: bold gradients, soft glows, tactile cards.
- **Colour palette**:
  - Background: deep dark plum/charcoal (#120d1a or #0e0b14) — not pure black, warmer
  - **Fire (positive)**: fiery orange-red gradient (#ff4500 → #ff8c00), with a warm glow/bloom effect — used for high positive scores and hot streaks
  - **Ice (negative)**: icy blue gradient (#00bfff → #7dd3fc), with a cold frost/glassy effect — used for negative scores and cold conversations
  - **Neutral**: soft lavender-grey (#9b8fac) at the midpoint
  - **Accent**: hot pink / rose (#f43f5e) for CTAs, badges, and highlights — the Tinder/dating app signature colour
  - White text with varying opacity for hierarchy
- **Score bar visual**: the evaluation bar itself uses a fire↔ice gradient — top half is fiery orange-red (positive territory), bottom half is icy blue (negative territory), with a glowing ember or frost effect at the current score position. At extreme positive: flames animate at the top. At extreme negative: frost/ice crystals animate at the bottom.
- **Typography**: rounded, friendly sans-serif — Nunito, Poppins, or DM Sans. Slightly larger than typical dev tooling to feel warm and readable.
- **Border radius**: 16–20px on cards (Tinder-style rounded cards), 24px on pills and buttons
- **Shadows**: soft coloured glows (rose/pink for positive actions, blue for neutral), not flat drop shadows
- **Icons**: filled or semi-filled icons (not just outlines) — warmer feel. Phosphor Icons or custom flame/ice icons for the score system.
- **Animations**: score bar flickers like a flame or frosts over when transitioning — satisfying, tactile. Card reveal animations (slide up). Subtle pulse on the score when a new message arrives.
- **Tone**: confident, seductive, slightly playful — like a charismatic friend who knows how to read a room. Not clinical, not corporate, not "productivity tool".

---

## Platform Constraints

- The **overlay plugin** must not break Telegram Web's existing layout — it should attach cleanly without covering the input box or the message list
- The sidebar is resizable: default width ~280px, minimum ~200px, maximum ~380px
- All UI must work at 1280×800 viewport minimum
- The native app is desktop-first (web app in browser), not mobile

---

## Screens to Produce (Mockup Checklist)

1. **Telegram Web + Chatfish sidebar** — active conversation, score bar showing positive, 3 reply suggestions visible
2. **Telegram Web + Chatfish sidebar** — collapsed state (thin strip, score bar only)
3. **Native chat — Live mode** — full two-column layout with sidebar
4. **Native chat — Practice mode** — AI opponent visible, mode switcher highlighted
5. **Control Panel — Profile tab**
6. **Control Panel — Connections tab**
7. **Interlocutor Profile** — AI insights panel, full scroll
8. **Score bar detail** — close-up of the evaluation bar at various states (positive, negative, neutral)


Attaching the initial screenshot of the HTML mockup to show the idea