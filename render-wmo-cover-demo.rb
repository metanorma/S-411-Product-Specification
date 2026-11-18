# frozen_string_literal: true

# Renders the WMO-publisher cover demo of the S-411 product specification
# through the modern two-stage lane (metanorma-document), producing
# document-wmo-cover-demo.mnd.html next to the source document.
require "metanorma/iho"
require "metanorma/iho/version"
require "metanorma/iho/front"
require "metanorma/iho/validate"
require "metanorma/iho/cleanup"
require "metanorma/iho/converter"
require "metanorma/iho/html"
require "isodoc/iho/init"
require "isodoc/iho/base_convert"
require "isodoc/iho/presentation_xml_convert"
require "isodoc/iho/html_convert"

ps_dir = File.expand_path("src/Documents/1.2.1/PS", __dir__)
demo = "document-wmo-cover-demo"
Dir.chdir(ps_dir) do
  processor = Metanorma::Iho::Processor.new
  sem = processor.input_to_isodoc(File.read("#{demo}.adoc"), "#{demo}.adoc")
  File.write("#{demo}.xml", sem)
  pres = IsoDoc::Iho::PresentationXMLConvert.new({})
    .convert(demo, sem, true)
  File.write("#{demo}.presentation.xml", pres)
  doc = Metanorma::Iho::Document::Root.from_xml(pres)
  html = Metanorma::Html::Generator.generate(doc)
  File.write("#{demo}.mnd.html", html)
  puts "rendered #{demo}.mnd.html (#{html.bytesize} bytes)"
end
