class HomeController < ApplicationController
  include BreadExpressHelpers::Baking

  def home
    @all_items
  	if logged_in? && current_user.role?(:admin)
  		@user = current_user
  		@customers = Customer.all
  		@items = Item.all
  		@orders = Order.all
  		@active_customers = Customer.active
  		@inactive_customers = Customer.inactive.paginate(:page => params[:page]).per_page(10)
  		@active_items = Item.active
  		@inactive_items = Item.inactive.paginate(:page => params[:page]).per_page(10)
  	elsif logged_in? && current_user.role?(:customer)
  		@user = current_user
  		@items = Item.all
    elsif logged_in? && current_user.role?(:baker)
      @user = current_user
      @muffins = create_baking_list_for("muffins")
      @bread = create_baking_list_for("bread")
      @pastries = create_baking_list_for("pastries")
  	end
  		
  end

  def about
  end

  def privacy
  end

  def contact
  end





end