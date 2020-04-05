module Tribes
  module Site
    class LoginWorld
      def initialize(args = {})
        @connection = args[:connection]
        @url = args[:url]
      end

      def download(data)
        credentials = [data[:token], 2, 'android']
        @connection.post(@url + "/m/g/login?hash=#{Tribes.calculate_mobile_hash(credentials)}") do |req|
          req.body = credentials.to_json
        end
      end
    end
  end
end