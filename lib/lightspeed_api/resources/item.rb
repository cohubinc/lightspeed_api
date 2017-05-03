class LightspeedItemNotFoundError < StandardError
  def initialize(msg='No Item found with current id/sku')
    super
  end
end

class DuplicatedLightspeedItemError < StandardError
  def initialize(msg='Multiple Items found with current id/sku')
    super
  end
end

module LightspeedApi
  class Item < Base

    self.id_param_key = 'itemCode'

    class << self
      def update(id, attrs = {})
        item_response = find(id)
        post_url = url + "/#{item_response['itemID']}.json"
        LightspeedCall.make('PUT') { HTTParty.put(post_url, body: attrs.to_json, headers: {Authorization: "Bearer #{LightspeedApi::OauthGrant.token}", 'Accept' => 'application/json', 'Content-Type' => 'application/json'}) }
      end

      def create(attrs = {})
        post_url = url
        LightspeedCall.make('POST') { HTTParty.post(post_url, body: attrs.to_json, headers: {Authorization: "Bearer #{LightspeedApi::OauthGrant.token}", 'Accept' => 'application/json', 'Content-Type' => 'application/json'}) }
      end

      def find_by_custom_sku(sku)
        encoded = URI.encode(sku)
        find_url = "#{url}/?customSku=#{encoded}"
        response = LightspeedCall.make('GET') { HTTParty.get(find_url, headers: headers) }
        check_response(response)
      end

      def where_by_sku(sku)
        encoded = URI.encode(sku)
        find_url = "#{url}/?customSku=#{encoded}"
        response = LightspeedCall.make('GET') { HTTParty.get(find_url, headers: headers) }
      end

      def find(id)
        find_url = "#{url}/#{id}.json"
        response = LightspeedCall.make('GET') {
          HTTParty.get(
              find_url, params: {"#{id_param_key}" =>  id }.to_json,
              headers: headers
          )}
        check_response(response)
      end

      def check_response(response)
        if response['Item'] && response['@attributes']['count'] == '1'
          response['Item']
        elsif response['Item'] && response['@attributes']['count'] > '1'
          raise DuplicatedLightspeedItemError
        elsif !response['Item']
          raise LightspeedItemNotFoundError
        end
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
        if qoh.to_i <= 0
          return 0
        end
        qoh
      end

    end # self
  end # class
end # module