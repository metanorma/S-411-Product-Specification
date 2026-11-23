#!/usr/bin/env ruby
# frozen_string_literal: true

# Extracts the DCEG attribute prose (IHO Definition lines, attribute
# type) from the hand-written attribute pages into the guidance YAML
# consumed by the [lutaml_ea_uml] liquid template. Codes and meanings
# stay in the EA model (S-411_v001.qea); only what the model lacks
# migrates here.
#
#   bundle exec ruby scripts/gen_guidance.rb

require "yaml"

DIR = File.expand_path("../sources/1.2.1/DCEG/attributes", __dir__)

pages = Dir[File.join(DIR, "*.adoc")].sort
guidance = {}

pages.each do |path|
  text = File.read(path).gsub(/\r\n/, "\n")
  name = text[/\[\[sec-([A-Za-z0-9_]+)\]\]/, 1] or next
  entry = {}

  if (m = text.match(/\*\*IHO Definition\*\* :#\s*(.+?)\s*(?:\n\n|\z)/m))
    entry["definition"] = m[1].strip.gsub(/\s+\n\s+/, " ")
  end

  entry["type"] = "enumeration" if text.include?("Attribute Type :# enumeration") ||
                                   text.match?(/\*\*Attribute Type.*enumeration/)

  values = text.scan(/^\.\s+(\d+)\s*\+\n\[underline\]\#\*\*IHO Definition\*\*\# :([^\n]+)$/)
  entry["values"] = values.map { |code, meaning| { "code" => code, "meaning" => meaning.strip } } unless values.empty?

  guidance[name] = entry
end

File.write(File.expand_path("../sources/1.2.1/DCEG/guidance/dceg-guidance.yaml", __dir__),
           YAML.dump(guidance))
puts "extracted #{guidance.size} entries"
