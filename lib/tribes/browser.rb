# frozen_string_literal: true

module Tribes
  class Browser
    attr_reader :current_page
    def initialize(session, configuration, village_list)
      @session = session
      @configuration = configuration
      @villages = village_list
      @browser_session = nil
      configure
      @browser_session = Capybara.current_session
      @pages = create_pages
      @current_page = nil
      set_headers
    end

    def load_page(page_id)
      page = find_page(page_id)
      url_builder = page.url.host(@configuration.game_server)
                        .add_query_param('village', @villages.selected_element[0])
      load_url(url_builder.url)
      @current_page = page
    end

    def load_url(url)
      @browser_session.visit url
    end

    def extract
      @current_page.extract(@browser_session.body)
    end

    private

    def configure
      # Capybara.register_driver :selenium do |app|
      #   Capybara::Selenium::Driver.new(app, browser: :firefox)
      # end
      Capybara.register_driver :apparition do |app|
        Capybara::Apparition::Driver.new(app, headless: false)
      end
      Capybara.javascript_driver = :apparition
      Capybara.configure do |config|
        config.default_max_wait_time = 5 # seconds
        config.default_driver = :apparition
      end
    end

    def find_page(page_id)
      @pages.find { |page| page.id == page_id }
    end

    def create_pages
      [Sites::PlaceScavenge.new(@browser_session)]
    end

    def set_headers
      @browser_session.driver.add_headers(Tribes::Headers.new.to_h)
    end
  end
end