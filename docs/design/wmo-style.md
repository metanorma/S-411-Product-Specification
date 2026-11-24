# WMO publication style for S-411 — design record

Status: implemented and shipped. This document records the design as
built: the taste architecture, the cover class system, the measured
typography, the HTML lanes, and the identifier wiring.

## Identity

WMO-published S-100 product specification, designed as typical WMO
with an IHO hint. Identity elements per the WMO corporate visual
identity: the green field with sweeping arcs (technical and guideline
covers), the plain Pantone covers (governance publications), the
reverse WMO lockup, the WEATHER CLIMATE WATER wordmark, Verdana for
documentation, and the IHO conjunction chip (partner logos on one
line, WMO first).

## Architecture

- Flavor: `metanorma-taste` `data/wmo` (base flavor iho). The taste
  carries the config (doctypes, fonts, cover-class carrier), the PDF
  stylesheet override (`wmo.xsl`, a fork of the IALA one applied over
  the base iho XSLs via the mn2pdf xsl-file-override flag - the IHO
  stylesheets are never modified), the customize metanorma.yml
  (namespaces, fonts, doctype registry), the HTML stylesheet, and the
  HTML cover page.
- Class carrier: the cover class rides
  `presentation-metadata-wmo-cover-class` (doctype-alias is overwritten
  by the presentation stage; keywords is ISO cover metadata - both
  rejected). The XSL matches plain values exactly.
- Asset resolution: cover art resolves per document directory through
  the baseassetpath mn2pdf parameter.

## Cover classes (WMO-No. B5/B14)

| Class | Field | Content |
| --- | --- | --- |
| manual | Pantone 187 red, plain | governance |
| guide | Pantone 341 teal, plain | governance |
| ec-report / congress-report | Pantone 108 yellow, plain | session reports |
| ra-report | Pantone 196 pink, plain | session reports |
| tc-report | Pantone 368 light green, plain | session reports |
| guideline | green arcs, no photo | WMO-No. 574-style guides |
| technical (default) | green arcs + photo band | S-411 PS; DCEG uses guideline |

Ink: white with the reverse lockup on the dark fields; WMO blue with
the blue/gold lockup on the three light Pantone solids. Pixel-verified
covers: P187 #C8102E, P341 #007672, P108 #FED141, P196 #F4B5C8,
P368 #A2D62D; back page #005BAA.

## Typography (measured off WMO-No. 1364)

- Body: Verdana 10pt (DejaVu Sans as the Linux companion), 121%
  leading (12.1pt measured), 10pt paragraph step.
- H1: heading blue rgb(47, 84, 150), capitals, regular weight, 14pt.
- H2: black, regular, 12pt. H3+: black, bold, 10pt.
- ToC: heading blue title, black entries with dot leaders, no bold.
- Tables: booktabs - horizontal rules only (cell sides and the
  table-level side frame must both drop; FOP resolves internal
  verticals against the table border), italic header row, no fill.
- Captions bold, above tables; figure captions bold, centred below.
- Running header: 9pt capitals title centred, page number outer.
- Links: plain hyperlink blue.

## HTML lanes

- Body stylesheet (htmlstyle.scss compiled to CSS by the taste's
  precompile gating): the same system in web form.
- Cover page (htmlcoverpage.html): the hero is the print cover's
  device - green field, inline-SVG arcs, white lockup, title,
  calendar-year edition, IHO conjunction chip, docidentifier - with
  the wordmark row beneath.
- Document HTML for the registry lane renders through the wmo flavor
  (metanorma-document --flavor wmo).

## Packaging rule

Released metanorma gems ship compiled CSS and never compile SCSS at
runtime: `rake scss_css_guard` fails any SCSS without a sibling CSS,
the default rake task gates it, releases recompile through
`pre_build_command`, and the configs wire the compiled files.

## Identifiers

pubid 2.0.48/2.0.49 carry the Wmo flavor (pubid#763): the printed
forms WMO-No. NNN, the S-100 lexical form as a WMO type (the IALA
fleet precedent), and the MRN extension. Pinned on the documents:
`urn:mrn:wmo:pub:s-411:ed1.2.1` (PS) and
`urn:mrn:wmo:pub:s-411:annex-a:ed1.2.0` (DCEG); the PS also pins
`docidentifier: S-411` so the Pubid::Wmo auto-mint (WMO 411) does not
leak into bibdata, the cover or the footer MRN. relaton 3.1.9 carries
the matching bibdata support (relaton#596).
