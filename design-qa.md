# Design QA · Inmíner Campus editorial home

## Comparison target

- Source visual truth: `C:\Users\Xmesa\Downloads\ChatGPT Image 14 ago 2026, 12_39_58.png`
- Source pixels: 1672 × 941.
- Intended implementation route: `/` on the local Vite preview.
- Intended comparison viewport: 1672 × 941 CSS px at device scale factor 1.
- State: desktop hero, initial load, top of page.
- Implementation screenshot: unavailable.
- Implementation pixels / CSS size / density: unavailable because no browser surface was available for capture.

## Evidence

- The source image was opened and inspected successfully.
- The local implementation returned HTTP 200 and included the new hero copy and optimized hero asset.
- The in-app browser connection was attempted after local preview startup, but the runtime reported no available browser instances.
- Full-view comparison evidence: blocked because a browser-rendered implementation screenshot could not be captured.
- Focused region comparison evidence: blocked for the same reason; header/logo, headline crop, CTAs and mobile composition could not be visually inspected.
- Primary interactions tested in a browser: none; browser unavailable.
- Browser console errors checked: no; browser unavailable.

## Findings

- [P1] Visual fidelity cannot be certified.
  - Location: desktop and mobile home route.
  - Evidence: the source is available, but there is no browser-rendered implementation capture to place beside it.
  - Impact: typography wrapping, logo treatment, image crop, contrast and responsive composition remain unverified visually.
  - Fix: open the local preview in an available browser, capture 1672 × 941 and a representative mobile viewport, compare both against the source, then address any visible P0/P1/P2 differences.

## Open questions

- Whether the monochrome inverse treatment of the supplied JPEG logo is optically clean against the hero.
- Whether the mobile crop keeps the operator visible while leaving sufficient quiet space for copy.

## Implementation checklist

- Capture the desktop hero at 1672 × 941.
- Test header links, both hero CTAs, mobile menu and first course CTA.
- Check browser console errors.
- Capture a 390 × 844 mobile view.
- Compare source and implementation together and resolve all P0/P1/P2 findings.

## Comparison history

- No visual iteration could be completed because browser capture was unavailable.

## Follow-up polish

- Defer P3 polish until the first browser-rendered comparison is available.

final result: blocked
