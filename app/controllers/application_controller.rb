class ApplicationController < ActionController::API
	before_action :current_user
	# helper_method :current_user
	
	def current_user
		user = User.find_by(email: params[:email])

		if user && user.authenticate(user.password)
			require 'pry'; binding.pry
			@_current_user = user
		else
			user = nil
		end
	end
end
