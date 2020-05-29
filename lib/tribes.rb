# frozen_string_literal: true

require 'tribes/version'
require 'tribes/parser'
require 'tribes/configuration'
require 'tribes/headers'
require 'tribes/server'
require 'tribes/data_service'
require 'tribes/service_container'
require 'tribes/session'
require 'tribes/data_list'
require 'tribes/village_list'
require 'tribes/world_list'
require 'tribes/recruitment'
require 'tribes/construction'
require 'tribes/questing'
require 'tribes/client'
require 'tribes/url_builder'
require 'tribes/extractors'
require 'tribes/browser'
require 'tribes/sites'
require 'capybara'
require 'capybara/apparition'
require 'selenium-webdriver'
require 'uri'
require 'faraday'
require 'faraday_middleware'
require 'faraday-cookie_jar'
require 'active_support/core_ext/hash'
require 'digest'
require 'json'
require 'pry'

module Tribes
  class Error < StandardError; end
  # Your code goes here...
  def self.calculate_mobile_hash(data)
    raise ArgumentError, 'Method accepts only arrays' unless data.is_a?(Array)

    secret = '2sB2jaeNEG6C01QOTldcgCKO'
    payload = secret + '-' + data.to_json
    Digest::SHA1.hexdigest(payload)
  end

  # convert 'HH:MM:SS' time string to timestamp
  def self.convert_time_str_to_timestamp(time_str)
    time_str.split(':').map(&:to_i).inject(0) { |a, b| a * 60 + b }
  end
end
