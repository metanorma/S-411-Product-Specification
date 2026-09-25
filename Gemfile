source "https://rubygems.org"

# metanorma-document HTML output for the published documents
# (document.mnd.html). Rendered by the generate workflow alongside the
# native metanorma HTML.
#
# Branch pins while the flavor model migration lands upstream:
# - metanorma-iho@feat/move-iho-document: the moved IhoDocument model +
#   Core::Flavors registration (68be197); unreleased.
# - metanorma-generic@feat/move-generic-document: the migrated generic
#   (3.5.1) the iho branch requires.
# - metanorma-standoc@feat/svgmap-block-wiring: standoc 3.5 line.
gem "metanorma-document", github: "metanorma/metanorma-document", branch: "main"
gem "metanorma-core", github: "metanorma/metanorma-core", branch: "main"
gem "metanorma-standoc", github: "metanorma/metanorma-standoc", branch: "feat/svgmap-block-wiring"
gem "isodoc", github: "metanorma/isodoc", branch: "main"
gem "metanorma-generic", github: "metanorma/metanorma-generic", branch: "feat/move-generic-document"
gem "metanorma-iho", github: "metanorma/metanorma-iho", branch: "feat/move-iho-document"
gem "metanorma-iso", github: "metanorma/metanorma-iso", branch: "feat/model-validation-migration"
gem "metanorma-mirror", "~> 1.0"
gem "lutaml-model", "~> 0.8.60"
gem "leptris", "~> 1.9.239"
gem "moxml", "~> 0.5.80"
gem "pubid", ">= 2.0.0.pre.alpha.9"
