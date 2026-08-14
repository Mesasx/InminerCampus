# Design QA — portada pública de InmínerCampus

## Evidencia

- Source visual truth: `C:\Users\Xmesa\.codex\generated_images\019fff4f-70ba-77d0-a66c-b8e9f40faa46\exec-f2778d4b-5675-490e-869e-7ab193cf0a9a.png`
- Browser-rendered implementation: `C:\Users\Xmesa\OneDrive\Escritorio\InminerCampus\design-qa-evidence\qa-implementation-desktop-passed-v2.png`
- Responsive implementation: `C:\Users\Xmesa\OneDrive\Escritorio\InminerCampus\design-qa-evidence\qa-implementation-mobile-passed-v2.png`
- Combined full-view comparison: `C:\Users\Xmesa\OneDrive\Escritorio\InminerCampus\design-qa-evidence\qa-comparison-desktop-passed.png`
- Desktop viewport and source pixels: 1673 × 940 CSS px, device scale factor 1; source and implementation are both 1673 × 940 px, so no density normalization was required.
- Responsive viewport: 390 × 844 CSS px, device scale factor 1; implementation capture is 390 × 844 px.
- State: public home route `/`, signed out, menu closed for the visual comparison.

## Full-view comparison

The final side-by-side comparison confirms the same information hierarchy and above-the-fold proportions as the selected design: 92 px public header, 730 px technical hero, three-line headline, two calls to action, diagonal mining machinery on the right, and a four-step horizontal learning sequence at the bottom. The implementation keeps the existing official logo, navigation, Spanish copy and real routes.

## Required fidelity surfaces

- Fonts and typography: Manrope and DM Sans retain the selected geometric engineering character. Headline scale, optical weight, three-line wrapping, line height and orange emphasis match the source closely. The heading has an explicit accessible label with the correct spaces and punctuation.
- Spacing and layout rhythm: desktop header, hero and journey heights align with the source viewport. Left margin, copy width, CTA grouping and four-column rhythm match. Mobile collapses to a readable single-column hero without horizontal overflow.
- Colors and tokens: deep Inmíner navy, official orange, cobalt drafting accents, graphite and warm off-white reproduce the selected palette with accessible contrast.
- Image quality and asset fidelity: the hero uses a project-local 1600 × 1000 generated raster asset with a sharp diagonal drill, quarry context and integrated drafting marks. No CSS drawing, placeholder, fake logo or generic card substitutes the selected imagery.
- Copy and content: the official-training eyebrow, headline, ITC 02.1.02 / ITC 02.0.02 paragraph, CTAs, navigation and four learning steps render correctly in Spanish.

## Focused evidence

A separate focused crop was not required: at 1673 × 940 the combined comparison keeps the logo, navigation, hero typography, CTA labels, machinery crop and journey copy legible at native density. The 390 × 844 capture separately verifies responsive headline wrapping, button sizing, menu affordance and image crop.

## Interaction and runtime checks

- The primary `Explorar cursos` action was activated and navigated to `/catalogo`; browser back returned to `/`.
- The mobile menu was opened at 390 × 844 and its navigation panel was visible with all expected links.
- Browser error collection returned no page errors after desktop load, mobile load, navigation and menu interaction.
- Browser console contained only Vite development connection messages and the React DevTools informational notice; no application error or Vite overlay was present.
- TypeScript typecheck, branding/mobile tests and production build passed.

## Comparison history

### Iteration 1

- Earlier evidence: `design-qa-evidence/qa-implementation-reference-viewport.png`.
- P1: the first hero asset was too vertical and visually dominant compared with the selected diagonal drill composition.
- P2: header and hero heights were short, the headline wrapped differently, and the learning sequence used vertical separators instead of the source's horizontal technical line.
- Fixes: regenerated the hero asset with the drill beginning near 58% of the frame, restored the quarry background, set the header and hero to source proportions, forced the selected three-line headline, and rebuilt the learning sequence with horizontal drafting dividers.

### Iteration 2

- Earlier evidence: `design-qa-evidence/qa-implementation-desktop-passed.png` and `design-qa-evidence/qa-implementation-mobile-final-v2.png`.
- P2: desktop headline scale was slightly undersized and mobile wrapping isolated a short word on its own line.
- Fixes: increased desktop headline scale, widened the heading track, made all three intended lines explicit, and added an exact accessible heading label.
- Post-fix evidence: `design-qa-evidence/qa-implementation-desktop-passed-v2.png`, `design-qa-evidence/qa-implementation-mobile-passed-v2.png`, and `design-qa-evidence/qa-comparison-desktop-passed.png`.

## Findings

No actionable P0, P1 or P2 differences remain.

## Follow-up polish

- P3: the generated drill is not the identical machine model depicted by ImageGen in the concept, but its scale, angle, crop, palette, quarry context and technical art direction are equivalent and appropriate for production use.

final result: passed
