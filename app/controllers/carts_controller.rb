class CartsController < ApplicationController

	def show 
		# authorize! :read, @order_items
		@order_items = current_order.order_items
	end
end
