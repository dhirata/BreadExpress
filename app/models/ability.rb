class Ability
  include CanCan::Ability
  
  def initialize(user)
    # set user to new User if not logged in
    user ||= User.new # i.e., a guest user
    
    if user.role?(:admin)
    	can :manage, :all

    elsif user.role?(:customer)
    	

    else
    	can :read, Item
      can :create, Customer
    end





  end
end