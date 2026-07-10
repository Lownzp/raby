# Raby Project Visual Baseline

## Sources of truth

Use this priority when sources disagree:

1. The user's latest explicit feedback or annotated screenshot.
2. Approved previews in `docs/design/raby-preview-spec/previews/`.
3. Current generated screenshots in `docs/prototypes/screenshots/`.
4. Older written design notes.

The home reference is `docs/design/raby-preview-spec/previews/01-home.png`. The reproducible implementation evidence is `docs/prototypes/screenshots/raby-home.png` at `430x932`.

## Visual language

- Mood: warm cream sticker journal, cute but still a usable records app.
- Hierarchy: rabbit first, health/record information second, decoration last.
- Main text: deep brown, not neutral black or gray.
- Action color: orange-yellow. Supporting surfaces may use pale yellow, pink, green, or blue.
- Depth: no drop shadows on cards, buttons, timeline actions, hero, or bottom navigation.
- Layering: use white sticker borders, warm fills, rounded corners, and spacing.
- Decoration: keep it sparse. Do not cover the rabbit, labels, or data with hearts, sparkles, or flowers.

## Typography

- Rabbit name only: `RabyChillRoundM` (寒蝉半圆体).
- All other Chinese UI text: `RabyChillRoundF` (寒蝉全圆体).
- Display titles: visually heavy, normally `FontWeight.w800` to `w900`.
- Body text: lighter, normally `FontWeight.w400` to `w600`.
- Bottom navigation labels: restrained; do not make them compete with 40 px icons.
- Keep `letterSpacing: 0`.
- Screenshot tests must explicitly load both bundled font families. Do not judge typography using a system fallback screenshot.

The font files are declared in `pubspec.yaml` and loaded by `tooling/screenshot_harness/raby_screenshot_test.dart`.

## Home page specifics

### Top bar

- The visible Raby logo lettering aligns with the hero card's left edge; account for transparent bitmap padding.
- Search, add, and settings are borderless circular actions with aligned 24 px artwork inside stable 48 px tap areas.
- Keep the gap between the top bar and hero compact.

### Hero

- Use the scene background and transparent rabbit sticker as separate layers.
- Keep the rabbit large and right-biased so the face remains the primary signal.
- Rabbit sticker variants cycle on tap and are precached.
- The rabbit cutout uses an approximately 4 px white outline.
- The hero card uses a broad rounded rectangle, white border, warm background, and no shadow.
- Pet name uses the half-round font; the nearby accent is a small carrot sticker.
- The weight panel must not cover too much of the rabbit.
- The mini trend is intentionally sparse at this size: no crowded axes, point labels, or grid.

### Quick actions and timeline

- Quick actions are sticker-bordered warm cards without shadows.
- Their illustration should read as an independent sticker, not an icon trapped in a heavy white box.
- Arrow controls are secondary and visually quiet.
- Timeline rows must remain compact enough to scan while preserving image and text breathing room.
- Timeline image has a thin white sticker border; its corner sticker may overlap by a few pixels.
- Auxiliary heart and overflow icons are borderless and aligned to the image's top and bottom edges respectively.

### Bottom navigation

- Container: pale warm background, moderate 22 px corner radius, 4 px white border, no shadow.
- Runtime height is currently 76 px.
- Selected and unselected icon artwork is fixed at 40x40 px.
- Selected surface is very pale and approximately one third of the navigation width.
- Keep icon-to-label spacing tight and label weight lighter than card titles.

## Responsive checks

Always start with `430x932`. For changes involving text, quick actions, cards, or navigation, also inspect:

- `390x844`
- `360x780`

Reject the result when text overlaps, important text truncates, a fixed control changes size between states, the hero crop hides the face, or the bottom bar covers content.

## Asset ownership

- Runtime assets: `assets/images/`.
- Bundled fonts: `assets/fonts/`.
- Approved previews: `docs/design/raby-preview-spec/previews/`.
- Raw design inputs: `docs/design/raby-preview-spec/素材/`.
- Generated or cutout intermediates worth retaining: `docs/design/raby-preview-spec/generated-source/`.
- Reproducible app screenshots: `docs/prototypes/screenshots/`.

Do not ship contact sheets, backups, or experimental variants through `pubspec.yaml`. Do not delete user source material merely because a production derivative exists.
