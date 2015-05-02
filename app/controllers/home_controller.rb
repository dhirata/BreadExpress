class HomeController < ApplicationController
  include BreadExpressHelpers::Baking

  def home
  	if logged_in? && current_user.role?(:admin)
  		@user = current_user
  		@customers = Customer.all
  		@items = Item.all
  		@orders = Order.all
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