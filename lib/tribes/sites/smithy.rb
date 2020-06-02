# frozen_string_literal: true

module Tribes
  module Sites
    class Smithy < Site
      def initialize(browser)
        super(browser)
        @id = 'smithy'
      end

      def url
        Tribes::URLBuilder.new.https.service('game.php')
                          .add_query_param('screen', 'smith')
      end

      def set_extractors
        [Tribes::Extractors::Tech.new]
      end

      def research(unit)
        research_buttons = @browser.has_css?('button.btn') ? @browser.all('button.btn') : []
        unit_button = research_buttons.find do |button|
          button_unit = /'.*'/.match(button[:onclick]).to_s.gsub("'", '')
          unit == button_unit
        end
        if unit_button
          unit_button.click
          return true
        end
        false
      end
    end
  end
end
