---
name: raby-flutter-development
description: Develop and visually verify the Raby Flutter app in D:/work/proj/raby. Use for Flutter UI or behavior changes, screenshot-to-code fidelity work, Raby fonts and image assets, screenshot harness updates, visual regression review, tests, or Git delivery of code and design artifacts.
---

# Raby Flutter Development

Use this workflow to keep code, screenshots, assets, and Git delivery aligned with the approved Raby visual direction.

## Non-Negotiables

- Work only in `D:/work/proj/raby`; never redirect work to `test-flow`.
- Treat the preview image and the user's latest annotated screenshot as visual truth. Do not stop at "close enough" when a visible mismatch remains.
- Preserve unrelated local changes. Inspect `git status --short` before editing and before staging.
- Read [references/project-visual-baseline.md](references/project-visual-baseline.md) before changing UI, typography, imagery, spacing, or navigation.
- Use production assets from `assets/`; keep design originals and intermediate source material under `docs/design/raby-preview-spec/`.

## Workflow

### 1. Establish the baseline

1. Inspect the target preview under `docs/design/raby-preview-spec/previews/`.
2. Inspect the latest implementation screenshot under `docs/prototypes/screenshots/`.
3. Read the owning widget, shared component, theme, and relevant widget tests.
4. List concrete deltas: position, width, height, padding, typography, color, border, image crop, and interaction.

For the home page, start with:

- `docs/design/raby-preview-spec/previews/01-home.png`
- `docs/prototypes/screenshots/raby-home.png`
- `lib/features/records/presentation/records_page.dart`
- `lib/shared/navigation/raby_shell.dart`
- `lib/app/theme/raby_theme.dart`
- `test/widget_test.dart`

### 2. Change one visual cluster at a time

Keep each pass coherent: top bar, hero, quick actions, timeline, or bottom navigation. Avoid changing every region before taking a screenshot; regressions become hard to attribute.

- Reuse current Raby tokens and component patterns.
- Use stable dimensions or constraints for fixed-format controls and images.
- Keep selected and unselected navigation icons the same size.
- Preserve semantics, tooltips, tap targets, empty/loading/error states, and routing.
- Add or update a focused widget test when behavior changes.

### 3. Handle image assets as a pipeline

1. Archive the source image under `docs/design/raby-preview-spec/`.
2. Produce the runtime image under `assets/images/` with a descriptive stable name.
3. Confirm real alpha transparency when the asset is a sticker; a checkerboard baked into RGB pixels is not transparency.
4. Add the runtime path to `pubspec.yaml`.
5. Precache switchable or animated hero assets to avoid first-tap flashing.
6. Run `scripts/verify-pubspec-assets.ps1 -RequireTracked` before committing.

For replaceable pet imagery, keep the background and rabbit sticker separate. Do not flatten them into one hero bitmap; future user-uploaded rabbit cutouts must remain possible.

### 4. Capture and inspect

Load the configured toolchain, then capture the affected page at the baseline viewport:

```powershell
. .\tooling\env.ps1
.\tooling\capture-screenshot.ps1 -Page home -Width 430 -Height 932
```

Visually compare the complete frame, not only the edited component. Check at least:

- alignment and crop;
- text wrapping, clipping, and actual font rendering;
- visual weight and density;
- white sticker borders with no accidental shadows;
- bottom navigation clearance;
- image loading and transition stability.

For layout-sensitive changes, also inspect `360x780` and `390x844`.

### 5. Verify code and delivery

Run focused tests during iteration, then the full gates before completion:

```powershell
. .\tooling\env.ps1
flutter analyze
flutter test
powershell -ExecutionPolicy Bypass -File .\.agents\skills\raby-flutter-development\scripts\verify-pubspec-assets.ps1 -RequireTracked
```

Before pushing, inspect the staged file list. After pushing asset work, verify the remote tree too:

```powershell
powershell -ExecutionPolicy Bypass -File .\.agents\skills\raby-flutter-development\scripts\verify-pubspec-assets.ps1 -RequireTracked -RemoteRef origin/main
```

Report which screenshot was regenerated, which tests ran, and whether any unrelated local files remain uncommitted.

## Lessons Encoded

- Visual fidelity improved fastest when component dimensions were measured and adjusted in small passes, not through broad restyling.
- The page felt heavy when controls, timeline rows, and navigation all grew together; inspect hierarchy after every size increase.
- Raby's sticker effect comes from white outlines, warm surfaces, spacing, and rounded geometry, not drop shadows.
- Font family must be loaded explicitly in both the app and screenshot harness; fallback fonts invalidate comparisons.
- Hero flexibility requires a scene background plus transparent rabbit sticker, with source assets retained for regeneration.
- Declaring an asset in `pubspec.yaml` is insufficient. It must exist, be tracked, and be present on the remote branch.
- Broad ignore rules such as `images/` can silently exclude nested runtime assets; anchor root-only ignores and run the asset verifier.
