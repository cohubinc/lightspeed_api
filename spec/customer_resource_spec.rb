require "spec_helper"

describe LightspeedApi::Customer do
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

  describe '.find_by_email(email)' do
    it "makes the correct GET request for searching by email" do
      response = LightspeedApi::Customer.find_by_email('someEmail')
      request = response.request
      expect(request.http_method).to eq(Net::HTTP::Get)
      expect(request.uri.to_s).to eq("https://api.merchantos.com/API/Account/accountID/Customer?load_relations=[%22Contact%22]&Contact.email=someEmail")
    end
  end

  describe '.find_by(query)' do
    it "makes the correct GET request searching by multiple attrs" do
      response = LightspeedApi::Customer.find_by({name: 'someName', email: 'someEmail'})
      request = response.request
      expect(request.http_method).to eq(Net::HTTP::Get)
      expect(request.options[:query]).to eq({:name=>"someName", :email=>"someEmail"})
      expect(request.uri.path).to eq("/API/Account/#{LightspeedApi.configuration.lightspeed_account_id}/Customer")
    end
  end
end