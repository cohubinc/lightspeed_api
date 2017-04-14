module LightspeedApi
  class SpecialOrder < Base

    self.id_param_key = 'specialOrderID'

    class << self
      def create(order)
        if order.is_a?(ShopifyAPI::DraftOrder)
        end
        post_url = url
        order_body = order.to_lightspeed
        puts 'Nothing happnse here yet'
        # LightspeedCall.make('POST') { HTTParty.post(post_url, body: order.to_json, headers: {Authorization: "Bearer #{LightspeedApi::OauthGrant.token}", 'Accept' => 'application/json'}) }
      end
    end
  end
end