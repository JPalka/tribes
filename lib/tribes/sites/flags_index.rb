# frozen_string_literal: true

module Tribes
  module Sites
    class FlagsIndex < Site
      def initialize(browser)
        super(browser)
        @id = 'flags_index'
      end

      def url
        Tribes::URLBuilder.new.https.service('game.php')
                          .add_query_param('screen', 'flags')
                          .add_query_param('mode', 'index')
      end

      def set_extractors
        [Tribes::Extractors::Flags.new]
      end

      def upgrade_flag(category, level)
        category_number = resolve_category(category)
        begin
          @browser.find("div#flag_box_#{category_number}_#{level} div.flag_upgrade").click
          true
        rescue Capybara::ElementNotFound
          false
        end
      end

      def assign_flag(category, level)
        category_number = resolve_category(category)
        begin
          @browser.find("div#flag_box_#{category_number}_#{level}").click
          sleep(1)
          @browser.find('a.btn-confirm-yes').click
          sleep(1)
          @browser.find('div#confirmation-box button.btn-confirm-yes').click
          true
        rescue Capybara::ElementNotFound
          false
        end
      end

      def remove_flag
        @browser.find('div#current_flag a').click
        @browser.has_css?('div.error') ? false : true
      rescue Capybara::ElementNotFound
        false
      end

      private

      def resolve_category(category)
        Tribes::FLAG_CATEGORIES.key(category) || category
      end
    end
  end
end
