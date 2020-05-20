# frozen_string_literal: true

module Tribes
  module Sites
    class PlaceScavenge < Site
      def initialize(browser)
        super(browser)
        @id = 'place_scavenge'
      end

      def url
        Tribes::URLBuilder.new.https.service('game.php')
                          .add_query_param('screen', 'place')
                          .add_query_param('mode', 'scavenge')
      end

      def scavenge(units, scavenging_level)
        raise 'Cannot fill scavenging form' unless fill_scavenge_form(units)

        element = ''
        begin
          element = @browser.find(".scavenge-option:nth-of-type(#{scavenging_level}) a.free_send_button")
                            .click
        rescue Capybara::ElementNotFound
          raise "Cannot send scavenging order level:#{scavenging_level}. Button not found."
        end
        # kill me
        sleep(1)
        # if ok button disappears then everything is ok
        return if element.inspect == 'Obsolete #<Capybara::Node::Element>'

        raise 'Could not send scavenging order. Button did not work for whatever reason. Not enough units maybe?'
      end

      def unlock_scavenge(scavenging_level)
        @browser.find(".scavenge-option:nth-of-type(#{scavenging_level}) a.unlock-button").click
        @browser.find('.scavenge-option-unlock-dialog a').click
      rescue Capybara::ElementNotFound
        raise "Scavenging level: #{scavenging_level} cannot be unlocked"
      end

      def set_extractors
        @extractors = [UnitCounts.new, ScavengingGroups.new, VillageData.new]
      end

      private

      def fill_scavenge_form(units)
        begin
          units.each do |unit, count|
            @browser.find("input[name=#{unit}]").set(count)
          end
        rescue Capybara::ElementNotFound
          clear_scavenge_form
          return false
        end
        true
      end

      def clear_scavenge_form
        @browser.all('input').each { |inp| inp.native.clear }
      end
    end
  end
end
