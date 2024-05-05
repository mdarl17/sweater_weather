class ApplicationController < ActionController::API
	rescue_from ArgumentError, with: :handle_errors
	rescue_from SecurityError, with: :handle_errors
	
	def handle_errors(exception)
		status_code = case exception
									when ArgumentError
										:bad_request
									when SecurityError
										:unauthorized
									else
										:unprocessable_entity
									end
		render json: { error: exception.message }, status: status_code
	end
		
		def current_user
			if params[:email]
				@_current_user = User.find_by(email: params[:email])
			elsif user_params[:email]
				@_current_user = User.find_by(email: user_params[:email])
			end
		end
	end
