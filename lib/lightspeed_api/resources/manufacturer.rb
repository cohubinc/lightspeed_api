module LightspeedApi
  class Manufacturer < Base

    self.id_param_key = 'manufacturerID'

    class << self
      def create(manufacturer)
        post_url = BASE_URL
        mfg = {name: manufacturer.name}
        LightspeedCall.make('POST') { HTTParty.post(post_url, body: mfg.to_json, headers: {Authorization: "Bearer #{LightspeedApi::OauthGrant.token}", 'Accept' => 'application/json'}) }
      end
    end
  end
end