class CustomersController < ApplicationController
  include ActionView::Helpers::NumberHelper
  before_action :check_login, except: [:new, :create]
  before_action :set_customer, only: [:show, :edit, :update, :destroy]
  authorize_resource
  
  def index
    if current_user.role? :customer
      @active_customers = Customer.active.where(user_id: current_user.id)
      @inactive_customers = Customer.inactive.where(user_id: current_user.id)    
    else
      @active_customers = Customer.active.alphabetical.paginate(:page => params[:page]).per_page(10)
      @inactive_customers = Customer.inactive.alphabetical.paginate(:page => params[:page]).per_page(10)
    end
  end

  def show
    @previous_orders = @customer.orders.chronological
  end

  def new
    @customer = Customer.new
    user = @customer.build_user
    address = @customer.addresses.build
  end

  def edit
    # reformat phone w/ dashes when displayed for editing (preference; not required)
    @customer.phone = number_to_phone(@customer.phone)
    # should have a user associated with customer, but just in case...

  end

  def create
    @customer = Customer.new(customer_params)
    if @customer.save && !logged_in?
      session[:user_id] = @customer.user_id
      redirect_to root_url, notice: "Thank you for signing up!"
    elsif @customer.save && current_user.role?(:admin)
      redirect_to @customer, notice: "#{@customer.proper_name} was added to the system."
    else
      render action: 'new'
    end
  end

  def update
    # just in case customer trying to hack the http request...
    reset_username_param unless current_user.role? :admin
    if @customer.update(customer_params)
      redirect_to @customer, notice: "#{@customer.proper_name} was revised in the system."
    else
      render action: 'edit'
    end
  end

  private
  def set_customer
    @customer = Customer.find(params[:id])
  end

  def customer_params
    #reset_role_param unless current_user && current_user.role?(:admin)
    params.require(:customer).permit(:first_name, :last_name, :email, :phone, :active, user_attributes: [:username, :password, :password_confirmation, :role, :active, :_destroy], addresses_attributes: [:recipient, :street_1, :street_2, :city, :state, :zip, :active, :is_billing, :_destroy])
  end

  def reset_role_param
    params[:customer][:user_attributes][:role] = "customer"
  end

  def reset_username_param
    params[:customer][:user_attributes][:username] = @customer.user.username
  end
end