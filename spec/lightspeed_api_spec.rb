require "spec_helper"

describe LightspeedApi do
  it "has a version number" do
    expect(LightspeedApi::VERSION).not_to be nil
  end

  describe ".const_missing" do
    it "returns a new class with the name of missing constant that inherits from LightspeedApi::Base " do
      random_constant = LightspeedApi::SomeRandomConstant
      expect(random_constant).to be_a(Class)
      expect(random_constant.name).to eq("LightspeedApi::SomeRandomConstant")
      expect(random_constant.superclass.name).to eq("LightspeedApi::Base")
    end
  end

  context "during initialization(configure)" do
    it "raises RuntimeError if a required environment variable is missing" do
      expect { LightspeedApi.configure do |config|
        config.lightspeed_clientID = ENV['lightspeed_clientID']
        config.lightspeed_clientSecret = ENV['lightspeed_clientSecret']
        config.lightspeed_refresh_token = ENV['lightspeed_refresh_token']
        config.lightspeed_account_id = ENV['lightspeed_account_id']
      end
      }.to raise_error(RuntimeError)
    end
  end

end

describe LightspeedApi::Base do
  before (:all) {
    LightspeedApi.configure do |config|
      config.lightspeed_clientID = 'clientID'
      config.lightspeed_clientSecret = 'clientSecret'
      config.lightspeed_refresh_token = 'refreshToken'
      config.lightspeed_account_id = 'accountID'
    end
  }


  describe "BASE_URL" do
    it "Has a BASE_URL constant" do
      expect(LightspeedApi::Base.constants).to include(:BASE_URL)
    end

    it "sets BASE_URL to merchants base url" do
      expect(LightspeedApi::Base::BASE_URL).to eq("https://api.merchantos.com/API/Account")
    end

  end

  describe ".url" do
    it "returns the url with the class name as route" do
      the_class = "SomeResource"
      expect(LightspeedApi::SomeResource.url).to eq("https://api.merchantos.com/API/Account/"+LightspeedApi.configuration.lightspeed_account_id+"/#{the_class}")
    end
  end

  describe ".headers" do
    it "returns a hash of headers with token content types" do
      LightspeedApi::OauthGrant.stub(:token) { 'sometokenhash' }
      expect(LightspeedApi::Base.headers.keys).to eq([:Authorization, "Accept", "Content-Type"])
    end
  end


  describe ".find on a basic resource with no overridden method" do
    it "makes a request to /API/Account/<account_id>/Manufacturer.json" do
      ENV['NO_ERRORS'] = 'true'
      AccessToken.stub(:find_by){ AccessToken.new(used_points: 1)}
      LightspeedApi::OauthGrant.stub(:token) { 'sometokenhash' }
      response = LightspeedApi::Manufacturer.all
      request = response.request
      expect(request.http_method).to eq(Net::HTTP::Get)
      expect(request.uri.path).to eq("/API/Account/#{LightspeedApi.configuration.lightspeed_account_id}/Manufacturer.json")
    end
  end

  describe ".find on a basic resource with no overridden method" do
    it "makes a request to LS API with the correct FIND path, body, and method" do
      ENV['NO_ERRORS'] = 'true'
      LightspeedApi::OauthGrant.stub(:token) { 'sometokenhash' }
      AccessToken.stub(:find_by){ AccessToken.new(used_points: 1)}
      response = LightspeedApi::Manufacturer.find(1)
      request = response.request
      expect(request.http_method).to eq(Net::HTTP::Get)
      expect(request.uri.path).to eq("/API/Account/#{LightspeedApi.configuration.lightspeed_account_id}/Manufacturer/1.json")
    end
  end

  describe ".update on a basic resource with no overridden method" do
    it "makes a request to LS API with the correct UPDATE path, body, and method" do
      ENV['NO_ERRORS'] = 'true'
      LightspeedApi::OauthGrant.stub(:token) { 'sometokenhash' }
      AccessToken.stub(:find_by){ AccessToken.new(used_points: 1)}
      response = LightspeedApi::Manufacturer.update(1, {name: 'SomeName'})
      request = response.request
      expect(request.raw_body).to eq "{\"name\":\"SomeName\"}"
      expect(request.http_method).to eq(Net::HTTP::Put)
      expect(request.uri.path).to eq("/API/Account/#{LightspeedApi.configuration.lightspeed_account_id}/Manufacturer/1.json")
    end
  end

  describe ".delete on a basic resource with no overridden method" do
    it "makes a request to LS API with the correct DELETE path, body, and method" do
      ENV['NO_ERRORS'] = 'true'
      LightspeedApi::OauthGrant.stub(:token) { 'sometokenhash' }
      AccessToken.stub(:find_by){ AccessToken.new(used_points: 1)}
      response = LightspeedApi::Manufacturer.delete(1)
      request = response.request
      expect(request.http_method).to eq(Net::HTTP::Delete)
      expect(request.uri.path).to eq("/API/Account/#{LightspeedApi.configuration.lightspeed_account_id}/Manufacturer/1.json")
    end
  end

  describe ".create on a basic resource with no overridden method" do
    it "makes a request to LS API with the correct CREATE path, body, and method" do
      ENV['NO_ERRORS'] = 'true'
      LightspeedApi::OauthGrant.stub(:token) { 'sometokenhash' }
      AccessToken.stub(:find_by){ AccessToken.new(used_points: 1)}
      response = LightspeedApi::Manufacturer.create({name: 'potatohead'})
      request = response.request
      expect(request.http_method).to eq(Net::HTTP::Post)
      expect(request.raw_body).to eq "{\"name\":\"potatohead\"}"
      expect(request.uri.path).to eq("/API/Account/#{LightspeedApi.configuration.lightspeed_account_id}/Manufacturer")
    end
  end
end
