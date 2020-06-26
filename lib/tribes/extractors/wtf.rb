# frozen_string_literal: true

module Tribes
  module Extractors
    # extracting worlds from some silly jsony format
    class Wtf < Extractor
      def extract(data)
        data.scan(/"[^"]*"/).map { |ele| ele.gsub('"', '') }.each_slice(2).each_with_object({}) do |match, hash|
          hash[match[0]] = match[1]
        end
      end
    end
  end
end
