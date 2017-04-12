module LightspeedApi
  class Item < Base

    self.id_param_key = 'itemCode'

    class << self
      def update(id, attrs = {})
        item_response = find(id)
        if item_response['Item'] && item_response['@attributes']['count'] == '1'
          post_url = url + "/#{item_response['Item']['itemID']}.json"
          LightspeedCall.make('PUT') { HTTParty.put(post_url, body: attrs.to_json, headers: {Authorization: "Bearer #{Lightspeed::OauthGrant.token}", 'Accept' => 'application/json', 'Content-Type' => 'application/json'}) }
        else
          CSV.open('./tmp/duplicated-id.csv', 'ab') do |row|
            row << item_response["Item"]
          end
          raise "Duplicated Item ID on Lightspeed. #{item_response['Item']}"
        end
      end

      def create(attrs = {} )
        post_url = url
        LightspeedCall.make('POST') { HTTParty.post(post_url, body: attrs.to_json, headers: {Authorization: "Bearer #{Lightspeed::OauthGrant.token}", 'Accept' => 'application/json', 'Content-Type' => 'application/json'}) }
      end
      #   # scale = ShopifyAPI::Order.first
      #   post_url = BASE_URL
      #   mfg = {order_lines: []}
      #   binding.pry
      #   LightspeedCall.make('POST') { HTTParty.post(post_url, body: mfg.to_json, headers: {Authorization: "Bearer #{Lightspeed::OauthGrant.token}",'Accept' => 'application/json'}) }
      # end
    end
  end
end