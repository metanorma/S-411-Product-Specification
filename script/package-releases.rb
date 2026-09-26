#!/usr/bin/env ruby
# Package compiled documents as metanorma-release "publications":
# releases/<slug>/<slug>.meta.json + <slug>.zip, one directory per
# document. Metadata comes from Metanorma's own compiled relaton files.
require "json"
require "fileutils"
require "zip"

SITE = File.expand_path(ARGV[0] || "_site/documents", __dir__ + "/..")
OUT = File.expand_path(ARGV[1] || "releases", __dir__ + "/..")

# Document directories by their basename; identifiers come from each
# document's own relaton file.
DOCS = %w[PS DCEG].freeze

def slug_from_identifier(identifier)
  identifier.to_s.strip
            .gsub(/\s+/, "-").gsub(/:+/, "-")
            .gsub(/[^a-zA-Z0-9-]/, "")
            .downcase.gsub(/--+/, "-").gsub(/[-.]+$/, "")
end

def relaton_identifier(rxl_path)
  require "relaton/bib"
  bib = Relaton::Bib::Item.from_xml(File.read(rxl_path))
  primary = Array(bib.docidentifier).find(&:primary) ||
            Array(bib.docidentifier).first
  primary&.content.to_s
end

def relaton_metadata(rxl_path)
  require "relaton/bib"
  bib = Relaton::Bib::Item.from_xml(File.read(rxl_path))
  first_title = Array(bib.title).first
  title = if first_title.respond_to?(:content) && first_title.content
            first_title.content.to_s
          else
            first_title.to_s
          end
  doctype = bib.doctype
  doctype = doctype.content if doctype.respond_to?(:content)
  {
    "title" => title.strip,
    "edition" => begin
      e = bib.edition
      e = e.first if e.is_a?(Array)
      e.respond_to?(:content) ? e.content.to_s : e.to_s
    end,
    "revdate" => begin
      d = Array(bib.date).find { |d| d.type == "published" }
      v = d && (d.at || d.from)
      v.respond_to?(:to_date) ? v.to_date.to_s : v.to_s
    end,
    "doctype" => doctype.to_s,
  }
end

def draft?(stage)
  stage.to_s.include?("draft")
end

FileUtils.mkdir_p(OUT)
Dir.glob("#{OUT}/*").each { |d| FileUtils.rm_rf(d) }

doc_dirs = Dir.glob("#{SITE}/**/")
  .select { |d| DOCS.include?(File.basename(d.chomp("/"))) }
  .sort_by { |d| d.count("/") }
  .uniq { |d| File.basename(d.chomp("/")) }
doc_dirs.each do |doc_dir|
  key = File.basename(doc_dir.chomp("/"))
  rxl = Dir.glob("#{doc_dir}document.rxl").first
  abort "no rxl for #{key}" unless rxl
  identifier = relaton_identifier(rxl)
  slug = slug_from_identifier(identifier)
  files = Dir.glob("#{doc_dir}document.*").reject do |f|
    f.end_with?(".err.html", ".presentation.xml") || File.basename(f) == "document.pdf.err"
  end

  meta = relaton_metadata(rxl)
  stage = "draft-development"
  formats = files.map { |f| File.extname(f).delete_prefix(".").sub("mnd", "html-mnd") }.uniq

  meta_dir = File.join(OUT, slug)
  FileUtils.mkdir_p(meta_dir)
  File.write(File.join(meta_dir, "#{slug}.meta.json"), JSON.pretty_generate({
    "identifier" => identifier,
    "title" => meta["title"],
    "edition" => meta["edition"],
    "stage" => stage,
    "doctype" => meta["doctype"] == "" ? "standard" : meta["doctype"],
    "revdate" => meta["revdate"],
    "channels" => ["public"],
    "formats" => formats,
  }))
  FileUtils.rm_f(File.join(meta_dir, "#{slug}.zip"))
  Zip::File.open(File.join(meta_dir, "#{slug}.zip"), create: true) do |zip|
    files.each do |f|
      # Flat site routing keys assets by file name; prefix with the slug
      # so PS and DCEG do not overwrite each other.
      ext = File.extname(f)
      base = File.basename(f, ".*").split(".").first
      mnd = f.include?(".mnd.") ? ".mnd" : ""
      zip.add("#{slug}#{mnd}#{ext}", f)
    end
  end
  puts "packaged #{slug} (#{files.size} files, edition #{meta['edition']})"
end
