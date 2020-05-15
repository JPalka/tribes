# frozen_string_literal: true

require 'tribes/version'
require 'tribes/parser'
require 'tribes/configuration'
require 'tribes/headers'
require 'tribes/controller_server'
require 'tribes/data_service'
require 'tribes/service_container'
require 'tribes/session'
require 'tribes/data_list'
require 'tribes/village_list'
require 'tribes/world_list'
require 'tribes/site'
require 'tribes/site/login'
require 'tribes/site/login_world'
require 'tribes/site/villages'
require 'tribes/site/village_data'
require 'tribes/site/main_construction_info'
require 'tribes/client'
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
end
