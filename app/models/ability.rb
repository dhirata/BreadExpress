class Ability
  include CanCan::Ability
  
  def initialize(user)
    # set user to new User if not logged in
    user ||= User.new # i.e., a guest user
      can :create, Customer
      can :new, Customer
      can :create, User
      can :new, User
      can :create, Address
      can :new, Address
    if user.role?(:admin)
    	can :manage, :all

    elsif user.role?(:customer)
    	can :manage, :all

    else
    	can :read, Item
      can :create, Customer
      can :new, Customer
      can :create, User
      can :new, User
      can :create, Address
      can :new, Address
    end





  end
end