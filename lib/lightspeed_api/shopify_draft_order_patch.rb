class NoLineItemsOnOrderError < StandardError
  def initialize(msg='There are no line items on this order. It cannot be created on Lightspeed.')
    super
  end
end
#  Monkey Patch Shopifys Draft Order to respond to to_lightspeed
module ShopifyDraftOrder
  refine ShopifyAPI::DraftOrder do

    def to_lightspeed

      if self.line_items.map { |x| x.sku }.include?("")
        raise NoLineItemsOnOrderError
      end


      items = self.line_items.map do |item|
        ls_item = Lightspeed::Item.find(item.sku)
        id = ls_item.fetch('Item', {}).fetch('itemID', nil)
        {SaleLine: [{itemID: id,
                     unitQuantity: item.quantity,
                     unitPrice: item.price,
                     isLayaway: true
                    }]}
      end

      {
          displayableSubtotal: self.total_price,
          customerID: 1,
          taxCategoryID: 0, # no tax category is 0
          employeeID: 1, # 0 didnt work
          shopID: 1, # 0 didnt work
          registerID: 1, # 0 didnt work
          SaleLines: items,
      }
    end
  end
end
