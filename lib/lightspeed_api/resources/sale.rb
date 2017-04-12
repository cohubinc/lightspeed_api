module LightspeedApi
  class Sale < Base
    using ShopifyDraftOrder
    using ShopifyOrder
    self.id_param_key = 'saleID'

    class << self
      def create(order)
        post_url = url
        order_attrs = order.to_lightspeed
        LightspeedCall.make('POST') { HTTParty.post(post_url, body: order_attrs.to_json, headers: {Authorization: "Bearer #{Lightspeed::OauthGrant.token}", 'Accept' => 'application/json'}) }
      end
    end
  end
end