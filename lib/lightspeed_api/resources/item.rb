module LightspeedApi
  class Item < Base

    self.id_param_key = 'itemCode'

    class << self
      def update(id, attrs = {})
        item_response = find(id)
        if item_response['Item'] && item_response['@attributes']['count'] == '1'
          post_url = url + "/#{item_response['Item']['itemID']}.json"
          LightspeedCall.make('PUT') { HTTParty.put(post_url, body: attrs.to_json, headers: {Authorization: "Bearer #{LightspeedApi::OauthGrant.token}", 'Accept' => 'application/json', 'Content-Type' => 'application/json'}) }
        else
          CSV.open('./tmp/duplicated-id.csv', 'ab') do |row|
            row << item_response["Item"]
          end
          raise "Duplicated Item ID on Lightspeed. #{item_response['Item']}"
        end
      end

      def create(attrs = {})
        post_url = url
        LightspeedCall.make('POST') { HTTParty.post(post_url, body: attrs.to_json, headers: {Authorization: "Bearer #{LightspeedApi::OauthGrant.token}", 'Accept' => 'application/json', 'Content-Type' => 'application/json'}) }
      end

      def update_with_inventory(id, attrs = {}, qoh)
        find_url = "#{url}/#{id}" +'?load_relations=["ItemShops"]'
        response = LightspeedCall.make('GET') {
          HTTParty.get(
              find_url,
              headers: {Authorization: "Bearer #{LightspeedApi::OauthGrant.token}", 'Accept' => 'application/json'}
          ) }
        shopItemID = response["Item"]["ItemShops"]["ItemShop"].find { |shop| shop['shopID'] == '1' }['itemShopID']
        qoh = check_qoh(qoh)
        inv_attrs = {ItemShops: {
            ItemShop: {
                itemShopID: shopItemID,
                shopID: 1,
                qoh: qoh
            }
        }}
        attrs.merge!(inv_attrs)
        update(id, attrs)
      end

      private
      def check_qoh(qoh)
        if qoh.blank? || qoh.nil? || !qoh
          return 0
        end
        qoh
      end
      #   # scale = ShopifyAPI::Order.first
      #   post_url = BASE_URL
      #   mfg = {order_lines: []}
      #   binding.pry
      #   LightspeedCall.make('POST') { HTTParty.post(post_url, body: mfg.to_json, headers: {Authorization: "Bearer #{LightspeedApi::OauthGrant.token}",'Accept' => 'application/json'}) }
      # end
    end
  end
end