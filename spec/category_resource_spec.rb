require "spec_helper"

describe LightspeedApi::Category do
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
      AccessToken.stub(:find_by) { AccessToken.new(used_points: 1) }
      LightspeedApi::OauthGrant.stub(:token) { 'sometokenhash' }
  }

  describe ".find_by_name" do
    it "makes the correct GET request"  do
      response = LightspeedApi::Category.find_by_name('someName')
      request = response.request
      expect(request.http_method).to eq(Net::HTTP::Get)
      expect(request.options[:params]).to eq "{\"name\":\"someName\"}"
      expect(request.uri.path).to eq("/API/Account/#{LightspeedApi.configuration.lightspeed_account_id}/Category")
    end
  end

  describe ".create" do
    it "makes the correct CREATE request and takes a object with certain attrs" do
      response = LightspeedApi::Category.create(OpenStruct.new(name: 'someName'))
      request = response.request
      expect(request.http_method).to eq(Net::HTTP::Post)
      expect(request.raw_body).to eq "{\"name\":\"someName\"}"
      expect(request.uri.path).to eq("/API/Account/#{LightspeedApi.configuration.lightspeed_account_id}/Category")
    end
  end
end