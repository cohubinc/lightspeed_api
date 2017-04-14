module LightspeedApi
  class Customer < Base

    self.id_param_key = 'customerID'

    class << self
      def create(manufacturer)
        post_url = url
        mfg = {name: manufacturer.name}
        LightspeedCall.make('POST') { HTTParty.post(post_url, body: mfg.to_json, headers: {Authorization: "Bearer #{LightspeedApi::OauthGrant.token}", 'Accept' => 'application/json'}) }
      end
    end
  end
end