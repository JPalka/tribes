# frozen_string_literal: true

module Tribes
  module Sites
    class PlaceCommand < Site
      def initialize(browser)
        super(browser)
        @id = 'place_command'
      end

      def url
        Tribes::URLBuilder.new.https.service('game.php')
                          .add_query_param('screen', 'place')
                          .add_query_param('mode', 'command')
      end

      def send_attack(x, y, units)
        prepare_form(x, y, units)
        @browser.find('button[name="attack"]').click
        return false if check_error

        confirm
      end

      def send_support(x, y, units)
        prepare_form(x, y, units)
        @browser.find('button[name="support"]').click
        return false if check_error

        confirm
      end

      private

      def confirm
        duration = @browser.find('span[data-duration]')['data-duration'].to_i
        @browser.find('button[name="submit"]').click
        duration
      end

      def check_error
        sleep(1)
        return true if @browser.has_css?('div.error_box')
      end

      def prepare_form(x, y, units)
        fill_units_form(units)
        fill_coord_form(x, y)
      end

      def fill_coord_form(x, y)
        @browser.find("input[name='x']").set(x)
        @browser.find("input[name='y']").set(y)
      end

      def set_extractors
        @extractors = [Tribes::Extractors::UnitCounts.new]
      end
    end
  end
end
