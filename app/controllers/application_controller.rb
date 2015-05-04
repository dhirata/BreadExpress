class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  #include BreadExpressHelpers::Cart
  #I think I want this everywhere....

  rescue_from CanCan::AccessDenied do |exception|
  	flash[:error] = "You are not authorized to take this action."
  	redirect_to home_path
  end
  
  rescue_from ActiveRecord::RecordNotFound do |exception|
    redirect_to home_path, error: "Record not found in the system."
  end

  private
  def current_user
  	@current_user ||= User.find(session[:user_id]) if session[:user_id]
  end 
  helper_method :current_user

  def current_order
    if !session[:order_id].nil?
      return Order.find(session[:order_id])
    else
      @new_order = Order.new(params[:order])
      @new_order.customer_id = current_user.customer.id
      if current_user.role? :customer
        @new_order.address_id = current_user.customer.addresses.first.id
      else
        @new_order.address_id = Address.all.first.id
      end
      @new_order.date = Date.today
      @new_order.grand_total = 0
      @new_order.save!
      return @new_order
    end
  end
  helper_method :current_order

  def logged_in?
  	current_user
  end
  helper_method :logged_in?

  def check_login
  	redirect_to login_url, alert: "You need to log in to view this page." if current_user.nil?
  end

end
