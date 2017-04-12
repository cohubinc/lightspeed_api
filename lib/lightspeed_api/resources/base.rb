module LightspeedApi
  class Base

    BASE_URL = "https://api.merchantos.com/API/Account"

    class_attribute :id_param_key

    class << self
      def url
        BASE_URL + "/#{ENV['lightspeed_account_id']}/" + self.name.demodulize
      end

      def all
        all_url = "#{url}.json"
        LightspeedCall.make('GET') { HTTParty.get(all_url, headers: {Authorization: "Bearer #{LightspeedApi::OauthGrant.token}", 'Accept' => 'application/json'}) }
      end

      def find(id)
        find_url = "#{url}/#{id}.json"
        LightspeedCall.make('GET') {
          HTTParty.get(
              find_url, params: {"#{id_param_key}" =>  id }.to_json,
            headers: {Authorization: "Bearer #{LightspeedApi::OauthGrant.token}", 'Accept' => 'application/json'}
         )}
      end

      # def update
      #
      # end

      def delete(id)
        delete_url = url + "#{id}.json"
        LightspeedCall.make('POST') { HTTParty.delete(delete_url, headers: {Authorization: "Bearer #{LightspeedApi::OauthGrant.token}"}) }
      end

      # Default just updated name
      def create(object)
        post_url = BASE_URL
        mfg = {name: object.name}
        LightspeedCall.make('POST') { HTTParty.post(post_url, body: mfg.to_json, headers: {Authorization: "Bearer #{LightspeedApi::OauthGrant.token}", 'Accept' => 'application/json'}) }
      end
    end
  end
end