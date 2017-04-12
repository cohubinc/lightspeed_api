module ShopifyOrder
  refine ShopifyAPI::Order do

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
                     completed: true
                    }]}
      end

      payments = self.line_items.map { |item| {amount: item.price} }

      {
          displayableSubtotal: self.total_price,
          customerID: 1,
          taxCategoryID: 0, # no tax category is 0
          employeeID: 1, # 0 didnt work
          shopID: 1, # 0 didnt work
          registerID: 1, # 0 didnt work
          SaleLines: items,
          SalePayments: payments
      }
    end
  end
end