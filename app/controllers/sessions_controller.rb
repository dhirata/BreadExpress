class SessionsController < ApplicationController
	def new
	end

	def create
		user = User.find_by_username(params[:username])
		if user && user.authenticate(params[:password])
			session[:user_id] = user.id
			redirect_to home_path, notice: "You are logged into Bread Express System"
		else
			flash.now.alert = "Username or password is invalid"
			render "new"
		end
	end 

	def destroy 
		session[:user_id] = nil
		session[:order_id] = nil
		redirect_to home_path, notice: "Logged out!"
	end
end
