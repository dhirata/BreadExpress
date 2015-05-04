class OrderItemsController < ApplicationController

	# before_action :set_order_item, only: [:update, :destroy]

	def create
		authorize! :new, @order_item
		@order = current_order
		@order_item = @order.order_items.new(order_item_params)
		@order.save
		session[:order_id] = @order.id
	end

	def update
		authorize! :update, @order_item
		@order = current_order
    	@order_item = @order.order_items.find(params[:id])
    	@order_item.update_attributes(order_item_params)
    	@order_items = @order.order_items
	end

	def destroy
		authorize! :destroy, @order_item
		@order = current_order
    	@order_item = @order.order_items.find(params[:id])
    	@order_item.destroy
    	@order_items = @order.order_items
	end

	private
	def set_order_item
		@order_item = OrderItem.find(params[:id])
	end

	def order_item_params
		params.require(:order_item).permit(:order_id, :item_id, :quantity)
	end

end
