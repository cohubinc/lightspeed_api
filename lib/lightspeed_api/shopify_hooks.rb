module LightspeedApi
  class LSShopifyHooks
    def self.create
      return Proc.new do |args|
        order = ShopifyAPI::Order.new(args[:order])
        LightspeedApi::Sale.create(order)
      end
    end
  end
end