class SessionsController < ApplicationController
	def create
		#render :text => request.env['rack.auth'].inspect
		#@andrewID = 
		#unless @auth = User.find_by_andrew_id(@andrew_id)
		#	@auth = User.create
		#	@auth = 
		#end
		#self.current_user = @auth.user
		
		#render :text => "Welcome, #{current_user.name}."
		
########	if Rails.env == "production"
########		auth = request.env["omniauth.auth"]
########		
########		if auth.nil?
########			raise Exceptions::AuthenticationException
########		end
########		
########		user = User.find_by_andrew_id(auth["uid"])
########	else
########		user = User.find_by_andrew_id('admin')
########	end

########	reset_session
########		
########	if user.nil?
########		raise Exceptions::AuthenticationException
########	else
########		session[:user_id] = user.id
########		flash[:notice] = "Welcome, #{current_user.name}!"
########	end
########	redirect_to request.env['omniauth.origin'] || root_url	
	end
	
	def destroy
#   @current_user = nil
#   reset_session

#   flash[:notice] = "You have been logged out"
#   redirect_to root_url(:subdomain => false)
  end
end
