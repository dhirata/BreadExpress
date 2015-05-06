class OrdersController < ApplicationController


  before_action :check_login
  before_action :set_order, only: [:show, :update, :destroy]
  authorize_resource
  
  def index
    if logged_in? && !current_user.role?(:customer)
      @pending_orders = Order.not_shipped.chronological.paginate(:page => params[:page]).per_page(5)
      @all_orders = Order.chronological.paginate(:page => params[:page]).per_page(5)
    else
      @pending_orders = current_user.customer.orders.not_shipped.chronological.paginate(:page => params[:page]).per_page(5)
      @all_orders = current_user.customer.orders.chronological.paginate(:page => params[:page]).per_page(5)
    end 
  end

  def show
    @order_items = @order.order_items.to_a
    if current_user.role?(:customer)
      @previous_orders = current_user.customer.orders.chronological.to_a
    else
      @previous_orders = @order.customer.orders.chronological.to_a
    end
  end

  def new
    @order = Order.new
  end

  def create
    @order = Order.new(order_params)

    if @order.save

      redirect_to @order, notice: "Thank you for ordering from Bread Express."
    else
      render action: 'new'
    end
  end

  def update
    if @order.update(order_params)
      @order.pay
      redirect_to @order, notice: "Your order was placed."
    else
      render action: 'checkout'
    end
  end

  def destroy
    @order.destroy
    redirect_to orders_url, notice: "This order was removed from the system."
  end

  def checkout
    @order = current_order
    @order_items = @order.order_items
    @shipping = @order.shipping_costs
    @grand_total = @order_items.collect { |oi| oi.valid? ? (oi.quantity * oi.item.current_price) : 0 }.sum + @order.shipping_costs
    @subtotal = @grand_total - @shipping
    if current_user.role? (:admin)
      @addresses = Address.active.by_recipient
    else
      @addresses = current_user.customer.addresses.active
    end
    @order.grand_total = @grand_total
    @new_order = Order.new
    @new_order.customer_id = @order.customer_id
    @new_order.address_id = @order.address_id
    @new_order.date = Date.today
    @new_order.grand_total = @grand_total
    @new_order.save
  end

  private
  def set_order
    @order = Order.find(params[:id])
  end

  def order_params
    params[:order][:expiration_year]= params[:order][:expiration_year].to_i
    params[:order][:expiration_month]= params[:order][:expiration_month].to_i
    params.require(:order).permit(:customer_id, :address_id, :date, :grand_total, :payment_receipt, :credit_card_number, :expiration_month, :expiration_year)
  end

end