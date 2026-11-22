source "https://rubygems.org"

# Aligned with the S-102 Product Specification repository layout: the
# core toolchain loads from git main, with versioned pins only where a
# dependency carries no stable contract yet.
gem "metanorma-cli", github: "metanorma/metanorma-cli", branch: "main"
gem "metanorma", github: "metanorma/metanorma", branch: "main"
gem "metanorma-iho", github: "metanorma/metanorma-iho", branch: "main"
# The documents carry the WMO publisher identity (mn-document-class:
# wmo); the wmo taste renders them. Branch pin while the taste PR is
# upstream; flip to main on merge.
gem "metanorma-taste", github: "metanorma/metanorma-taste",
    branch: "feat/wmo-pdf-stylesheet"

# Document registry lane (document.mnd.html + releases packaging in
# the generate workflow)
gem "metanorma-document", github: "metanorma/metanorma-document", branch: "main"
gem "metanorma-core", github: "metanorma/metanorma-core", branch: "main"
gem "metanorma-release", github: "metanorma/metanorma-release", branch: "main"

gem "metanorma-mirror", "~> 1.0"
gem "lutaml-model", "~> 0.8.63"
gem "leptris", "~> 1.9.239"
gem "moxml", "~> 0.6.0"
gem "pubid", ">= 2.0.0.pre.alpha.9"
# isodoc-i18n resolves from main; metanorma-standoc and isodoc are
# pulled in transitively and declared here when a branch pin is
# needed (duplicates would shadow, first declaration wins)
gem "isodoc-i18n", github: "metanorma/isodoc-i18n", branch: "main"

# Gems published to rubygems ship precompiled static CSS, so
# sassc-embedded is only needed when loading isodoc from git (main)
# as done above.
gem "sassc-embedded"
