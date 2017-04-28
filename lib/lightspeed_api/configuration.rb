module LightspeedApi
  class Configuration
    attr_accessor :lightspeed_clientID,:lightspeed_clientSecret,:lightspeed_refresh_token,:lightspeed_account_id

    def initialize
      @lightspeed_clientID = false
      @lightspeed_clientSecret = false
      @lightspeed_refresh_token = false
      @lightspeed_account_id = false
    end
  end
end