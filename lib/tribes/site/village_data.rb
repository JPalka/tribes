module Tribes
  module Site
    class VillageData
      def initialize(args = {})
        @connection = args[:connection]
        @url = args[:url]
      end

      def download(data)
        credentials = [data[:sid], data[:village_id]]
        @connection.post(@url + "/m/g/village_data?hash=#{Tribes.calculate_mobile_hash(credentials)}") do |req|
          req.body = credentials.to_json
        end
      end
    end
  end
end
