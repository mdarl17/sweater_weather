class ApplicationController < ActionController::API
	before_action :current_user
	# helper_method :current_user

	private
	def current_user
		@_current_user = User.find_by(email: params[:email])
	end
end
