module LightspeedApi
  class SpecialOrder < Base
    # using ShopifyDraftOrder
    # using ShopifyOrder
    self.id_param_key = 'specialOrderID'

    class << self
      def create(order)
        post_url = url
        order_attrs = order.to_lightspeed
        # binding.pry
        if order_attrs
          LightspeedCall.make('POST') { HTTParty.post(post_url, body: order_attrs.to_json, headers: {Authorization: "Bearer #{LightspeedApi::OauthGrant.token}", 'Accept' => 'application/json'}) }
        end
      end
    end
  end
end