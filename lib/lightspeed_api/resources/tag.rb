module LightspeedApi
  class Tag < Base

    self.id_param_key = 'tagID'

    class << self
      def create(scale)
        post_url = url
        mfg = {name: scale.name}
        LightspeedCall.make('POST') { HTTParty.post(post_url, body: mfg.to_json, headers: {Authorization: "Bearer #{Lightspeed::OauthGrant.token}", 'Accept' => 'application/json'}) }
      end
    end
  end
end