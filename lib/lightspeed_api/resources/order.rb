module LightspeedApi
  class Order < Base

    self.id_param_key = 'orderID'
    class << self
      # def create(scale)
      #   # scale = ShopifyAPI::Order.first
      #   post_url = BASE_URL
      #   mfg = {order_lines: []}
      #   binding.pry
      #   LightspeedCall.make('POST') { HTTParty.post(post_url, body: mfg.to_json, headers: {Authorization: "Bearer #{LightspeedApi::OauthGrant.token}",'Accept' => 'application/json'}) }
      # end
    end
  end
end