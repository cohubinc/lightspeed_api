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
