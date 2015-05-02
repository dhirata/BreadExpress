class HomeController < ApplicationController
  include BreadExpressHelpers::Baking

  def home
  	if logged_in? && current_user.role?(:admin)
  		@user = current_user
  		@customers = Customer.all
  		@items = Item.all
  		@orders = Order.all
  		@active_customers = Customer.active
  		@inactive_customers = Customer.inactive
  		@active_items = Item.active
  		@inactive_items = Item.inactive
  	elsif logged_in? && current_user.role?(:customer)
  		@user = current_user
  	end
  		
  end

  def about
  end

  def privacy
  end

  def contact
  end





end