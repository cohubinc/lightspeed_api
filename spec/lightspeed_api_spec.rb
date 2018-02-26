require "spec_helper"     describe LightspeedApi do  
  it "has a version number" do  
    expect(LightspeedApi::VERSION).not_to be nil
   
  end
        describe ".const_missing" do  
    it "returns a new class with the name of missing constant that inherits from LightspeedApi::Base " do  
      random_constant = LightspeedApi::SomeRandomConstant
        expect(random_constant).to be_a(Class)   expect(random_constant.name).to eq("LightspeedApi::SomeRandomConstant")   expect(random_constant.superclass.name).to eq("LightspeedApi::Base")
     
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
  before (:all) {      LightspeedApi.configure do |config|  
    config.lightspeed_clientID = 'somePropertySetting'
      config.lightspeed_clientSecret = 'somePropertySetting'
      config.lightspeed_refresh_token = 'somePropertySetting'
      config.lightspeed_account_id = 'somePropertySetting'
   
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
         describe ".all" do  
    it "returns the first 100 records from lightspeeds API for a valid resource" do  
      LightspeedApi::OauthGrant.stub(:token) { 'sometokenhash' }
        LightspeedCall.stub(:make) { nil }
        response = LightspeedApi::Manufacturer.all
        request = response.request
        expect(response.keys).to include("Manufacturer", "@attributes")   expect(request.uri.path).to eq("/API/Account/147343/Manufacturer.json")
     
    end
   
  end
        describe ".find" do  
    it "does something" do  
      LightspeedApi::Item.find_by({name: 'Baldwin Builders Plate Pin'})
       
    end
   
  end
    describe ".update" do  
    it "does something" do   
    end
   
  end
    describe ".delete" do  
    it "does something" do   
    end
   
  end
    describe ".create" do  
    it "does something" do   
    end
   
  end
 
end
 
