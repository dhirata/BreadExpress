class ItemsController < ApplicationController
	before_action :set_item, only: [:show, :edit, :update, :destroy]
	before_filter :check_login

	def index
		authorize! :read, @items
		@items = Item.alphabetical.paginate(page: params[:page]).per_page(10)
		@active_items = Item.alphabetical.active.paginate(page: params[:page]).per_page(10)
		@inactive_items = Item.alphabetical.inactive.paginate(page: params[:page]).per_page(10)
	end

	def show
		authorize! :read, @item 
	end

	def new 
		authorize! :create, @item 
		@item = Item.new
	end

	def edit
		authorize! :update, @item 
	end

	def create
		authorize! :new, @item 
		@item = Item.new(params[:item])
		if @item.save
			flash[:notice] = "Sucessfully created #{@item.name}."
			redirect_to @item
		else
			render action: 'new'
		end
	end


	private
	def set_item
		@item = Item.find(params[:id])
	end
end
