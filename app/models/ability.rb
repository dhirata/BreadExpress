class Ability
  include CanCan::Ability
  
  def initialize(user)
    # set user to new User if not logged in
    user ||= User.new # i.e., a guest user

    if user.role?(:admin)
    	can :manage, :all

    elsif user.role?(:customer)
    	can :read, User do |u|
        u.id == user.id
      end

      can :edit, User do |u|
        u.id == user.id
      end

      can :read, Customer do |c|
        user.customer.id == c.id
      end

      can :edit, Customer do |c|
        user.customer.id == c.id
      end

      can :read, Order do |this_order|
        my_orders = user.customer.orders.map(&:id)
        my_orders.include? this_order.id
      end

      can :checkout, Order 
 
      can :update, Order do |this_order|
        my_orders = user.customer.orders.map(&:id)
        my_orders.include? this_order.id
      end

      can :create, Order do |this_order|
        my_orders = user.customer.orders.map(&:id)
        my_orders.include? this_order.id
      end

      can :manage, OrderItem

      can :read, :all

    elsif user.role?(:shipper)

      can :manage, OrderItem  

    else
      can :create, Customer
      can :new, Customer
      can :create, User
      can :new, User
      can :create, Address
      can :new, Address
    end

  end
end