module Tribes
  module Site
    class MainConstructionInfo
      def initialize(args = {})
        @connection = args[:connection]
        @url = args[:url]
      end

      def download(data)
        credentials = [data[:sid], data[:village_id]]
        @connection.post(@url + "/m/g/main_construction_info?hash=#{Tribes.calculate_mobile_hash(credentials)}") do |req|
          req.body = credentials.to_json
        end
      end
    end
  end
end
