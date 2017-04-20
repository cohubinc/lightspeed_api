class NoLineItemsOnOrderError < StandardError
  def initialize(msg='There are no line items on this order. It cannot be created on Lightspeed.')
    super
  end
end
#  Monkey Patch Shopifys Draft Order to respond to to_lightspeed
module ShopifyDraftOrder
  refine ShopifyAPI::DraftOrder do

    def to_lightspeed

      if self.line_items.map { |x| x.sku }.include?("") || self.email.nil?
        begin
          raise NoLineItemsOnOrderError
        rescue
          CSV.open('./tmp/no_line_items_on_orders.csv', 'ab', headers: ['shopify_draft_order_id', 'user_email', 'error']) do |row|
            row << [self.id, self.email, 'No line items on order']
          end
        end
        return false
      end


      items = self.line_items.map do |item|
        begin
          ls_item = LightspeedApi::Item.find(item.sku)
        rescue => e
          CSV.open('./tmp/no_line_items_on_orders.csv', 'ab') do |row|
            row << [self.id, self.email, e.message ,item.sku, item.title]
          end
          puts 'No Item Found Lightspeed'
          return false
        end
        if ls_item['Item'].nil?
          CSV.open('./tmp/no_line_items_on_orders.csv', 'ab') do |row|
            row << [self.id, self.email, 'Item Not Found On Lightspeed']
          end
          puts 'No Item Found On Lightspeed'
          return false
        end
        if ls_item.fetch('Item', {}).is_a?(Array)
          CSV.open('./tmp/no_line_items_on_orders.csv', 'ab') do |row|
            row << [self.id, self.email, 'Item Not Found On Lightspeed']
          end
          puts 'No Item Found On Lightspeed'
          return false
        end
        id = ls_item.fetch('Item', {}).fetch('itemID', nil)
        {SaleLine: [{itemID: id,
                     unitQuantity: item.quantity,
                     unitPrice: item.price,
                     isLayaway: true
                    }]}
      end
      customer = LightspeedApi::Customer.find_by_email(self.email)

      if customer['Customer'].nil? || customer['Customer'].is_a?(Array)
        CSV.open('./tmp/no_line_items_on_orders.csv', 'ab') do |row|
          row << [self.id, self.email, 'Customer not found in Lightspeed']
        end
        puts 'No Customer Found'
        return false
      end

      puts "Making Order for Draft Order: #{self.id}"
      customer_id = customer['Customer']['customerID']
      {
          displayableSubtotal: self.total_price,
          customerID: customer_id,
          taxCategoryID: 0, # no tax category is 0
          employeeID: 1, # 0 didnt work
          shopID: 1, # 0 didnt work
          registerID: 1, # 0 didnt work
          SaleLines: items,
      }
    end
  end
end
