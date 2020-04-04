# frozen_string_literal: true

require 'tribes/version'
require 'tribes/parser'
require 'tribes/client'
require 'uri'
require 'faraday'
require 'faraday_middleware'
require 'active_support/core_ext'

module Tribes
  class Error < StandardError; end
  # Your code goes here...
end
