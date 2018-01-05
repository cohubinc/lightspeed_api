module LightspeedApi
  class Base

    BASE_URL = "https://api.merchantos.com/API/Account"

    class_attribute :id_param_key

    class << self

      def headers
        {Authorization: "Bearer #{LightspeedApi::OauthGrant.token}",'Accept' => 'application/json', 'Content-Type' => 'application/json' }
      end

      def url
        BASE_URL + "/#{LightspeedApi.configuration.lightspeed_account_id}/" + self.name.demodulize
      end

      def get_bucket_level
        basic_url = BASE_URL + ".json"
        response = HTTParty.get(basic_url, headers: headers)
      end

      def where_by_attributes(attributes)
        find_url = "#{url}.json?#{attributes}"
        response = LightspeedCall.make('GET') { HTTParty.get(find_url, headers: headers) }
      end

      def all(query = {},params = {},body = {})
        all_url = "#{url}.json?"
        LightspeedCall.make('GET') { HTTParty.get(all_url, query: query,params: params,body:body, headers: headers) }
      end

      def find(id)
        find_url = "#{url}/#{id}.json"
        LightspeedCall.make('GET') {
          HTTParty.get(
              find_url, params: {"#{id_param_key}" =>  id }.to_json,
            headers: headers
         )}
      end

      def update(id,params)
        update_url = url + "/#{id}.json"
        LightspeedCall.make('PUT') { HTTParty.put(update_url, body: params.to_json, headers: headers) }
      end

      def delete(id)
        delete_url = url + "/#{id}.json"
        LightspeedCall.make('DELETE') { HTTParty.delete(delete_url, headers: headers) }
      end

      # Default just updated name
      def create(params)
        post_url = url
        LightspeedCall.make('POST') { HTTParty.post(post_url, body: params.to_json, headers: {Authorization: "Bearer #{LightspeedApi::OauthGrant.token}", 'Accept' => 'application/json',  'Content-Type' => 'application/json' }) }
      end
    end
  end
end