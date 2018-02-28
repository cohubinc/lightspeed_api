require "spec_helper"

describe LightspeedApi::Manufacturer do
  before (:all) {
    LightspeedApi.configure do |config|
      config.lightspeed_clientID = 'clientID'
      config.lightspeed_clientSecret = 'clientSecret'
      config.lightspeed_refresh_token = 'refreshToken'
      config.lightspeed_account_id = 'accountID'
    end
  }

  before(:each) {
    ENV['NO_ERRORS'] = 'true'
    AccessToken.stub(:find_or_create_by) { AccessToken.new(used_points: 1) }
    LightspeedApi::OauthGrant.stub(:token) { 'sometokenhash' }
  }


  describe ".create" do
    it "makes the correct CREATE request and takes a object with certain attrs" do
      response = LightspeedApi::Manufacturer.create({name: 'someName'})
      request = response.request
      expect(request.http_method).to eq(Net::HTTP::Post)
      expect(request.raw_body).to eq "{\"name\":\"someName\"}"
      expect(request.uri.path).to eq("/API/Account/#{LightspeedApi.configuration.lightspeed_account_id}/Manufacturer")
    end
  end
end