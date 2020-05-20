# frozen_string_literal: true

module Tribes
  module Sites
    class Site
      attr_reader :id
      def initialize(browser)
        @browser = browser
        @extractors = set_extractors
      end

      def url; end

      def extract(html)
        @extractors.inject({}) do |result, extractor|
          result.merge!(extractor.extract(html))
        end
      end

      private

      def set_extractors; end
    end
  end
end
