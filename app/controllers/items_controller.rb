class ItemsController < ApplicationController
	before_action :set_item, only: [:show, :edit, :update, :destroy]
	before_filter :check_login, except: [:index, :show]

	def index
		authorize! :read, @items
		@items = Item.alphabetical.paginate(page: params[:page]).per_page(10)
		@active_items = Item.alphabetical.active.paginate(page: params[:page]).per_page(10)
		@inactive_items = Item.alphabetical.inactive.paginate(page: params[:page]).per_page(10)
		@order_item = current_order.order_items.new
	end

	def show
		authorize! :read, @item 
		@item_prices = @item.item_prices.chronological
		@recommended_items = Item.for_category(@item.category)
	end

	def new 
		authorize! :create, @item 
		@item = Item.new
		@item.item_prices.build
	end

	def edit
		authorize! :update, @item 
	end

	def create
		authorize! :new, @item 
		@item = Item.new(item_params)
		if @item.save
			flash[:notice] = "Successfully created #{@item.name}."
			redirect_to @item
		else
			render action: 'new'
		end
	end

	def update
		authorize! :update, @item
		if(@item.update(item_params))
			flash[:notice] = "Successfully updated #{@item.name}."
			redirect_to @item
		else
			render action: 'edit'
		end
	end

	def destroy 
		authorize! :destroy, @item
		@item.destroy
		flash[:notice] = "Successfully removed #{@item.name} from Bread Express system."
		redirect_to items_url
	end

	private
	def set_item
		@item = Item.find(params[:id])
	end

	def item_params
    	params.require(:item).permit(:name, :description, :picture, :category, :units_per_item, :weight, :active, item_prices_attributes: [:id, :price, :start_date, :_destroy])
  	end
end
