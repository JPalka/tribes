# frozen_string_literal: true

module Tribes
  class DataList
    attr_accessor :selected_element
    def initialize(configuration)
      @configuration = configuration
      @list = []
      @selected_element = nil
    end

    def download(session)
      response = @controller.load(post_data(session))
      @controller.check_errors(response)
      load(response['result'])
      response
    end

    def load(_json_data)
      throw 'load method not implemented'
    end

    def select(_entity_id)
      throw 'select method not implemented'
    end

    private

    def post_data(_session)
      throw 'post_data method not implemented'
    end
  end
end
