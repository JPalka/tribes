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

      def clear_inputs
        @browser.all('input').each { |input| input.set('') }
      end

      def fill_units_form(units)
        begin
          units.each do |unit, count|
            @browser.find("input[name=#{unit}]").set(count)
          end
        rescue Capybara::ElementNotFound
          clear_inputs
          return false
        end
        true
      end
    end
  end
end
