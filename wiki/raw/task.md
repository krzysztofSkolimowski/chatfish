# Chatfish — Re-skin Wireframes into Production Mockups

Chatfish is an AI dating / conversation coach. A browser overlay + native app reads chats (Telegram, WhatsApp, etc.), scores the conversation in real time, and suggests replies.

## Source files

- **Logo:** `/Users/krzysztofskolimowski/projects/chatfish/wiki/mockups/chatfish-logo.htm`
- **Wireframes:** `/Users/krzysztofskolimowski/projects/chatfish/wiki/mockups/chatfish-wireframes.htm`

1. `chatfish-wireframes.htm` — 17 screens, the functional spec. Hand-drawn Caveat style. Every panel, state, and interaction I want is already in there.
2. `chatfish-logo.htm` + `chatfish-logo.svg` — the brand system v4. Palette, type pairing, colorways, in-the-wild examples.

## Goal

Re-skin the wireframes into production-quality HTML mockups, preserving every panel and flow from the wireframes while swapping the visual language for the brand system in the logo file.

## Deliverable

A single file `chatfish-design.htm`, same top-nav structure as `chatfish-wireframes.htm` (tabs ① through ⑰), rendering every screen from the wireframes in the finished brand style. Self-contained HTML — one file, Google Fonts allowed, no build step.

## Rules — functionality (from wireframes)

Reproduce every panel, state, and micro-interaction the wireframes show. Non-negotiable list:

- ① Overlay collapsed · ② Overlay expanded (right sidebar)
- ③ Native Live · ④ Native Practice (with Chat Double picker) · ⑤ Native Replay (picker + in-progress)
- ⑥ Settings Profile · ⑦ Settings Connections · ⑧ Interlocutor Profile (with score trend SVG + key moments)
- ⑨ Score Bar — all 5 states + anatomy + delta examples
- ⑩ Sidebar — all 3 options (A/B/C) + comparison notes
- ⑪ Suggestion Card · ⑫ Contact Row (incl. platform badges) · ⑬ Composer (all 9+ states, eval chip lifecycle, tray re-composition)
- ⑭ Per-Person Settings · ⑮ Animated States motion spec · ⑯ Empty/Loading/Error · ⑰ Atomic Components library

The persistent always-on score strip, the suggestions tray above compose, the independently-collapsible right sidebar, the mode tabs (Live/Practice/Replay), the eval chip inside the composer, and the tray that re-composes cards around the user's draft must all work as described.

## Rules — visual language (from logo file)

Throw out the wireframe aesthetic. Use the brand system instead.

### Color tokens — use these exact values

```css
--navy:       #00183c;  /* ink / primary text */
--navy-2:     #183c54;
--deep-blue:  #306c90;  /* coach blue — cool UI accent */
--mid-blue:   #4890b4;
--splash:     #78c0d8;  /* cool accent */
--foam:       #b4d8d8;  /* cool background tint */
--love:       #d83060;  /* heartbeat — primary emotional accent (matches, hearts) */
--love-soft:  #f7b8c8;
--fire:       #ef5a2a;  /* flame — passion, urgency, streaks, send-it CTAs */
--fire-soft:  #ffb38a;
--amber:      #e8a24a;  /* rare warm glow — premium accents only */
--cream:      #f5efe2;  /* card surface */
--bg:         #eadfcb;  /* page background */
--ink:        #00183c;
```

### Color mapping from wireframes → brand

- wireframe `--ink` (#1a1a2e) → `--navy`
- wireframe `--paper` (#faf9f6) → `--cream`
- wireframe `--paper2` (#f0ede6) → `--bg`
- wireframe `--fire` (#e8650a) → `--fire` (#ef5a2a) for passion/streaks/send; or `--love` when it represents affection/match
- wireframe `--ice` (#3a8fd4) → `--deep-blue` / `--splash`
- wireframe `--rose` (#d4436a) → `--love`

**Frequency ladder** (don't overuse warmth): blues carry the brand, love is the emotional voice, fire is for moments, amber is rare.

### Typography

```html
<link href="https://fonts.googleapis.com/css2?family=Bricolage+Grotesque:wght@700;800&family=Fraunces:ital,opsz,wght@0,9..144,800;1,9..144,800&family=Space+Grotesk:wght@400;500;700&display=swap" rel="stylesheet">
```

- **Fraunces 800 italic** — display serif (hero numbers, screen titles, score readouts)
- **Bricolage Grotesque 800** — display sans (section headers, mode tab labels)
- **Space Grotesk 500/700** — all UI, body, buttons, microcopy
- **Wordmark:** `chat` in Fraunces italic 800 + `fish` in Bricolage 800, e.g. for nav logo + practice-mode "Double" headers

### Form language

- **Border radius:** cards 18–22px, buttons/pills 14–999px, inputs 14px, chips 999px. No sharp 3–4px corners like the wireframes.
- **Shadows:** soft, not offset. `filter: drop-shadow(0 20px 40px rgba(0,24,60,0.10))` for hero cards; `0 2px 8px rgba(0,24,60,0.06)` for small surfaces. Do NOT use the wireframe `box-shadow:3px 3px 0 var(--ink)` offset-marker effect anywhere.
- **Borders:** 1px `rgba(0,24,60,.14)` for quiet cards, 2px solid navy only for strong CTAs and the primary score-strip frame. No 2.5px wireframe borders.
- **Backgrounds:** page uses the radial-gradient treatment from the logo hero —

  ```css
  background:
    radial-gradient(1200px 600px at 50% -10%, #e1d6bd 0%, transparent 60%),
    var(--bg);
  ```

  Accent cards use soft love/fire radial glows (see `.hero .glow-love` and `.glow-fire` in the logo file) instead of the hand-drawn hatching.
- **Score strip:** redesign as a refined gradient bar. Fire zone top = love→fire gradient; ice zone bottom = deep-blue→splash gradient; lavender midpoint stays. Marker = white pill with navy border + soft glow on change. At extremes, keep the flame/frost particles but render as small animated CSS `::before` elements, not emoji. Reduced-motion turns drift off but keeps tint + static icon — same rule as the wireframes.
- **Suggestion cards:** cream surface, 14px radius, subtle love-tint on hover (`0 6px 16px rgba(216,48,96,0.15)`), top-pick card uses a 2px fire border + tiny fire glow. Grade chip = pill with fire/neutral/ice fills from the brand palette.
- **Pills / tags:** use the `.pill`, `.btn`, `.pill.love`, `.pill.fire`, `.pill.amber`, `.pill.blue` treatments from the logo file verbatim.
- **Avatars:** replace the diagonal-stripe placeholder with a soft navy→deep-blue gradient; platform badges keep their real brand colors (tg #2aabee, wa #25d366, ig gradient, etc.).
- **Logo usage:** use `chatfish-logo.svg` in the top nav (replace the 🐟 + "Chatfish" lockup), in onboarding, and as the mini-icon pattern from the logo file for settings rails.

## Copy / tone

- Keep all wireframe copy verbatim (it's been tuned). Don't rewrite suggestion text, coach tips, or notes.
- Replace the wireframe's explanatory `.note` blocks (→ …) with quieter footnotes below each screen, in Space Grotesk 500, color `#5c6b82`, no arrow prefix.

## Nice-to-haves (do if you have room)

- Keep the tweaks panel + edit-mode `postMessage` plumbing from the bottom of the wireframes file — the host framework reads it.
- Keep the same `localStorage.cf_wf_screen` tab persistence.
- Add a subtle 1px foam-tinted grid to the background only on atomic-components and motion-spec screens, to echo the logo file's spec-sheet feel.

## What "done" looks like

Side-by-side with the wireframes file, I should be able to click through all 17 tabs and see the same panels, same data, same states — but rendered as something I'd ship, not something drawn in a notebook. Every flow from the wireframes works; every color and font comes from the logo file; nothing has the hand-drawn Caveat aesthetic.

Return the complete `chatfish-design.htm` as one code block.

it has to be put in `mockups` folder

---

Paste the three attached files with this prompt. If your chat UI has trouble with the 2943-line wireframes file, split the deliverable into two passes: pass 1 — screens ①–⑧ (full app flows); pass 2 — screens ⑨–⑰ (component library + states). Keep the same `<style>` block across both so they merge cleanly.
