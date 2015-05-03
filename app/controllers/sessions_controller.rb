class SessionsController < ApplicationController
	def create
      if Rails.env == "development"
        user = user.find_by_andrew_id('admin')
      end
	end
	
  def destroy
  end
end
