class CartsController < ApplicationController

	def show 
		authorize! :read, @order_items
		@order = current_order
		@order_items = @order.order_items
	end
end
