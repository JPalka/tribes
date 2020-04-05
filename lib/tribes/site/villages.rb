module Tribes
  module Site
    class Villages
      def initialize(args = {})
        @connection = args[:connection]
        @url = args[:url]
      end

      def download(data)
        credentials = [data[:sid], nil]
        @connection.post(@url + "/m/g/villages_get?hash=#{Tribes.calculate_mobile_hash(credentials)}") do |req|
          req.body = credentials.to_json
        end
      end
    end
  end
end
