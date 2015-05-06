class CartsController < ApplicationController

	def show 
		authorize! :read, @order_items
		@order = current_order
		@order_items = @order.order_items
		@order.grand_total = @order_items.collect { |oi| oi.valid? ? (oi.quantity * oi.item.current_price) : 0 }.sum + @order.shipping_costs
    	@order.save!
	end
end
