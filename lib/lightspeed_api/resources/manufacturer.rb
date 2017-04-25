module LightspeedApi
  class Manufacturer < Base

    self.id_param_key = 'manufacturerID'

    class << self
      def create(params)
        post_url = url
        LightspeedCall.make('POST') { HTTParty.post(post_url, body: params.to_json, headers: {Authorization: "Bearer #{LightspeedApi::OauthGrant.token}", 'Accept' => 'application/json', 'Content-Type' => 'application/json' }) }
      end
    end
  end
end