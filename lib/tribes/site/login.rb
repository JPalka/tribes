module Tribes
  module Site
    class Login
      def initialize(args = {})
        @connection = args[:connection]
      end

      def download(data)
        credentials = [data[:login], data[:password], '2.30.0']
        @connection.post("/m/m/login?hash=#{Tribes.calculate_mobile_hash(credentials)}") do |req|
          req.body = credentials.to_json
        end
      end
    end
  end
end
