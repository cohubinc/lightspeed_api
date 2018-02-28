require "spec_helper"

describe LightspeedCall do
  before (:all) {
    WebMock.disable_net_connect!(allow_localhost: true)
    LightspeedApi.configure do |config|
      config.lightspeed_clientID = 'clientID'
      config.lightspeed_clientSecret = 'clientSecret'
      config.lightspeed_refresh_token = 'refreshToken'
      config.lightspeed_account_id = 'accountID'
    end
  }

  after(:all) {
    WebMock.allow_net_connect!
  }

  before(:each) {
    ENV['NO_ERRORS'] = 'true'
    LightspeedApi::OauthGrant.stub(:token) { 'sometokenhash' }
  }

  describe '.parse_headers(response)' do
    it "does something" do

    end

  end

  describe '.make(type)' do
    describe "does not receive a 200 response" do

      before(:each) {
        ENV['NO_ERRORS'] = nil
        AccessToken.stub(:find_or_create_by) { AccessToken.new(used_points: 1) }
        LightspeedApi::OauthGrant.stub(:token) { 'sometokenhash' }
      }

      it "should raise an error" do
        expect { LightspeedApi::Manufacturer.find(123) }.to raise_error
      end
    end

    describe "receives a 200 response" do

      before(:each) {
        stub_request(:get, "https://api.merchantos.com/API/Account/accountID/Manufacturer.json").
            with(headers: {'Accept' => 'application/json', 'Authorization' => 'Bearer sometokenhash', 'Content-Type' => 'application/json'}).
            to_return(status: 200, body: {"@attributes" => {"count" => "392", "offset" => "0", "limit" => "100"},
                                          "Manufacturer" =>
                                              [{"manufacturerID" => "25",
                                                "name" => "A Line Products",
                                                "createTime" => "2017-03-30T22:09:57+00:00",
                                                "timeStamp" => "2017-04-25T02:29:06+00:00"},
                                               {"manufacturerID" => "26",
                                                "name" => "Accu Lites",
                                                "createTime" => "2017-03-30T22:09:57+00:00",
                                                "timeStamp" => "2017-03-30T23:09:57+00:00"}]}.to_json, headers: {'Content-Type' => 'application/json', 'x-ls-api-bucket-level': '40/90' })
      }

      it "returns the response if it receives a 200 response" do
        ENV['NO_ERRORS'] = nil
        AccessToken.stub(:find_or_create_by) { AccessToken.new(used_points: 50) }
        LightspeedApi::OauthGrant.stub(:token) { 'sometokenhash' }
        response = LightspeedApi::Manufacturer.all
        expect(response.body).to eq({"@attributes" => {"count" => "392", "offset" => "0", "limit" => "100"},
                                     "Manufacturer" =>
                                         [{"manufacturerID" => "25",
                                           "name" => "A Line Products",
                                           "createTime" => "2017-03-30T22:09:57+00:00",
                                           "timeStamp" => "2017-04-25T02:29:06+00:00"},
                                          {"manufacturerID" => "26",
                                           "name" => "Accu Lites",
                                           "createTime" => "2017-03-30T22:09:57+00:00",
                                           "timeStamp" => "2017-03-30T23:09:57+00:00"}]}.to_json)
      end

      it "checks calls" do
        ENV['NO_ERRORS'] = nil
        AccessToken.stub(:find_or_create_by) { AccessToken.new(used_points: 60) }
        LightspeedApi::OauthGrant.stub(:token) { 'sometokenhash' }
        expect_any_instance_of(LightspeedCall).to receive(:check_calls)
        response = LightspeedApi::Manufacturer.all
      end
    end
  end

  describe '.check_calls(type)' do
    before(:each) do
      stub_request(:get, "https://api.merchantos.com/API/Account/accountID/Manufacturer.json").
          with(headers: {'Accept' => 'application/json', 'Authorization' => 'Bearer sometokenhash', 'Content-Type' => 'application/json'}).
          to_return(status: 200, body: {"@attributes" => {"count" => "392", "offset" => "0", "limit" => "100"},
                                        "Manufacturer" =>
                                            [{"manufacturerID" => "25",
                                              "name" => "A Line Products",
                                              "createTime" => "2017-03-30T22:09:57+00:00",
                                              "timeStamp" => "2017-04-25T02:29:06+00:00"},
                                             {"manufacturerID" => "26",
                                              "name" => "Accu Lites",
                                              "createTime" => "2017-03-30T22:09:57+00:00",
                                              "timeStamp" => "2017-03-30T23:09:57+00:00"}]}.to_json, headers: {'Content-Type' => 'application/json', 'x-ls-api-bucket-level': '60/75'})
    end

    it "waits for the correct amount of time if call will put over limit ((total_if_call_is_made) - bucket_level) / (default drip of 2)" do
      ENV['NO_ERRORS'] = nil
      AccessToken.stub(:find_or_create_by) { AccessToken.new(used_points: 86, bucket_level: 90) }
      LightspeedApi::OauthGrant.stub(:token) { 'sometokenhash' }
      expect_any_instance_of(LightspeedCall).to receive(:sleep).with(0.5)
      response = LightspeedApi::Manufacturer.all
    end
  end

  describe '.check_calls(type)' do
    before(:each) do
      stub_request(:get, "https://api.merchantos.com/API/Account/accountID/Manufacturer.json").
          with(headers: {'Accept' => 'application/json', 'Authorization' => 'Bearer sometokenhash', 'Content-Type' => 'application/json'}).
          to_return(status: 200, body: {"@attributes" => {"count" => "392", "offset" => "0", "limit" => "100"},
                                        "Manufacturer" =>
                                            [{"manufacturerID" => "25",
                                              "name" => "A Line Products",
                                              "createTime" => "2017-03-30T22:09:57+00:00",
                                              "timeStamp" => "2017-04-25T02:29:06+00:00"},
                                             {"manufacturerID" => "26",
                                              "name" => "Accu Lites",
                                              "createTime" => "2017-03-30T22:09:57+00:00",
                                              "timeStamp" => "2017-03-30T23:09:57+00:00"}]}.to_json, headers: {'Content-Type' => 'application/json', 'x-ls-api-bucket-level': '1/76'})
    end

    it "Does not wait if we are total_if_call_is_made < bucket_level " do
      ENV['NO_ERRORS'] = nil
      AccessToken.stub(:find_or_create_by) { AccessToken.new(used_points: 60, bucket_level: 66) }
      LightspeedApi::OauthGrant.stub(:token) { 'sometokenhash' }
      expect_any_instance_of(LightspeedCall).to_not receive(:sleep)
      response = LightspeedApi::Manufacturer.all
    end
  end

end