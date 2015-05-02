class ItemPricesController < ApplicationController
	before_action :check_login

	def new
		authorize! :new, @item_price
		@item_price = ItemPrice.new
		@item_price.item_id = params[:id] unless params[:id].nil?
	end

	def create
		authorize! :new, @item_price
		@item_price = ItemPrice.new(item_price_params)
		if @item_price.save
			flash[:notice] = "#{@item_price.item.name} is $#{@item_price.price}."
			redirect_to items_url
		else
			render action: 'new'
		end
	end

	private
	def item_price_params
		params.require(:item_price).permit(:item_id, :price, :start_date)
	end

end
