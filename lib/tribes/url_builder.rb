# frozen_string_literal: true

module Tribes
  class URLBuilder
    def initialize
      @protocol = nil
      @host = nil
      @params = {}
      @api_shill = nil
      @service = nil
    end

    def add_query_param(key, value)
      @params[key] = value
      self
    end

    def game_server_api
      @api_shill = 'm/g/'
      self
    end

    def master_server_api
      @api_shill = 'm/m/'
      self
    end

    def https
      @protocol = 'https://'
      self
    end

    def host(host)
      @host = host + '/'
      self
    end

    def service(service)
      @service = service
      self
    end

    def url
      raise "protocol can't be null" if @protocol.nil?

      raise "host can't be null" if @host.nil?

      url = @protocol + @host
      url << @api_shill if @api_shill
      url << @service if @service
      url << params_slug
      url.chomp('/')
    end

    private

    def params_slug
      slug = String.new
      @params.each_with_index do |(key, val), idx|
        slug << (idx.zero? ? '?' : '&') << key.to_s + '=' + val.to_s
      end
      slug
    end
  end
end
