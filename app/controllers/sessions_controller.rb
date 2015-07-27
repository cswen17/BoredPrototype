<<<<<<< HEAD
=======
class SessionsController < ApplicationController
    @current_user = nil

	def create
      if Rails.env == "development"
        @current_user = user.find_by_andrew_id('admin')
      end
	end
	
  def destroy
  end
end
>>>>>>> cleanup
