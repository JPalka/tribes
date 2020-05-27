# frozen_string_literal: true

module Tribes
  module Sites
    class ConfigXml < Extractor
      def extract(data)
        doc = Nokogiri::HTML(data)
        xml = doc.css('div#webkit-xml-viewer-source-xml').first.content

        { config: Hash.from_xml(xml)['config'] }
      end
    end
  end
end
