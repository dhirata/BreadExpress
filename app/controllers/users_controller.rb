class UsersController < ApplicationController
	before_filter :check_login, except: [:new, :create]
	before_action :set_user, only: [:show, :edit, :update, :destroy]

	def new
		@user = User.new
	end

	def create
		@user = User.new(user_params)
		if(@user.save)
			session[:user_id] = @user.id
			redirect_to home_path, notice: "Thank you for sigining up! You are now logged in."
		else
			render action: 'new'
		end
	end

	def edit
		authorize! :edit, @user
	end

	def index 
		authorize! :read, @users 
		@users = User.paginate(:page => params[:page]).per_page(5)
	end

	def show
		authorize! :read, :all
		if @user.customer
			@user_customer = @user.customer
			@user_orders = @user_customer.orders 
			@user_addresses = @user_customer.addresses
		end 
	end

	def update
		authorize! :update, @user
		if @user.update_attributes(params[:user])
			flash[:notice] = "#{@user.customer.proper_name} is updated."
			redirect_to @user
		else
			render action: 'edit'
		end
	end

	def destroy
		authorize! :destroy, @user
		@user.destroy
		flash[:notice] = "Successfully removed #{@user.customer.proper_name} from Bread Express System."
		redirect_to users_url
	end

	private
	def set_user
		@user = User.find(params[:id])
	end

	def user_params
		# if current_user && current_user.role?(:admin)
			params.require(:user).permit(:username, :password, :password_confirmation, :role, :active)
		# else 
		# 	params.require(:user).permit(:username, :password, :password_confirmation, :active)
		# end
	end

end
