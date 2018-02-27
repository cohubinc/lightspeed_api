require "spec_helper"

describe LightspeedApi::Order do
  before (:all) {
    LightspeedApi.configure do |config|
      config.lightspeed_clientID = 'clientID'
      config.lightspeed_clientSecret = 'clientSecret'
      config.lightspeed_refresh_token = 'refreshToken'
      config.lightspeed_account_id = 'accountID'
    end
  }

  describe ".id_param_key" do
    it "has a special id name" do
      expect(LightspeedApi::Order.id_param_key).to eq('orderID')
    end
  end
end