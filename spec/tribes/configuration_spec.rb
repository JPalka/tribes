RSpec.describe Tribes::Client::Configuration do
  before do
    @stub = stub_request(:get, 'https://www.tribalwars.net/backend/get_servers.php').to_return(
      status: 200,
      body: 'a:12:{s:5:"en107";s:28:"https://en107.tribalwars.net";s:5:"en110";s:28:"https://en110.tribalwars.net";s:5:"en111";s:28:"https://en111.tribalwars.net";s:5:"en112";s:28:"https://en112.tribalwars.net";s:5:"en113";s:28:"https://en113.tribalwars.net";s:4:"enp8";s:27:"https://enp8.tribalwars.net";}',
      headers: {}
    )
  end
  
end