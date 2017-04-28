module LightspeedApi
  class OauthGrant
    class << self
      def authorize

        tokenURL = "https://cloud.merchantos.com/oauth/access_token.php";

        postFields = {
            'client_id' => LightspeedApi.configuration.lightspeed_clientID,
            'client_secret' => LightspeedApi.configuration.lightspeed_clientSecret,
            'refresh_token' => LightspeedApi.configuration.lightspeed_refresh_token,
            'grant_type' => 'refresh_token'
        }

        response = HTTParty.post(tokenURL, body: postFields.to_json, headers: {'Content-Type' => 'application/json'})
        token = AccessToken.find_by(app: 'lightspeed')

        if token
          token.access_token = response['access_token']
          token.expires_at = response['expires_in']
          token.save
        else
          token = AccessToken.new
          token.app = 'lightspeed'
          token.access_token = response['access_token']
          token.expires_at = response['expires_in']
          token.refresh_token = response['refresh_token']
          token.save
        end
        token.access_token
      end

      def token
        token = AccessToken.find_by(app: 'lightspeed')
        if token && (token.expires_at == '0' || Time.at(token.expires_at) > Time.now)
          token.access_token
        else
          authorize
        end
      end
    end
  end
end