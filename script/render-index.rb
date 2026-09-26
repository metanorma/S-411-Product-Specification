#!/usr/bin/env ruby
# Render the site index with Liquid from the metanorma-release
# aggregated data (_data/documents.json). Metanorma-family templating,
# replacing the relaton XSL index.
require "yaml"
require "liquid"
require "json"
require "fileutils"

ROOT = File.expand_path("..", __dir__)
DATA = File.join(ROOT, "_data/documents.json")
TEMPLATE = File.join(ROOT, "site/templates/index.html.liquid")
OUT = File.join(ROOT, "_site/index.html")

docs = JSON.parse(File.read(DATA))["items"]
generated = Time.now.utc.strftime("%Y-%m-%dT%H:%M:%SZ")

manifest = YAML.safe_load_file(File.join(ROOT, "metanorma.yml"))
collection = manifest.dig("metanorma", "collection") || {}

format_count = docs.flat_map { |d| d["files"] }.map { |f| f["format"] }.uniq.size

# Brand continuity: reuse the header logo exactly as the published
# documents render it (metanorma-document theme), extracted from the
# compiled output.
logo_html = nil
Dir.glob(File.join(ROOT, "_site/docs/*.mnd.html")).sort.each do |f|
  body = File.read(f)
  if (m = body.match(%r{<span class="brand-logo[^"]*"[^>]*>\s*(<svg.*?</svg>)}m))
    logo_html = m[1]
    break
  end
end

html = Liquid::Template.parse(File.read(TEMPLATE)).render(
  { "documents" => docs,
    "generated" => generated,
    "organization" => collection["organization"],
    "site_name" => collection["name"],
    "format_count" => format_count,
    "logo_html" => logo_html },
)
FileUtils.mkdir_p(File.dirname(OUT))
File.write(OUT, html)
assets_dst = File.join(ROOT, "_site/assets")
FileUtils.rm_rf(assets_dst)
FileUtils.cp_r(File.join(ROOT, "site/assets"), assets_dst)
puts "rendered #{OUT} (#{docs.size} documents)"
