class Api::V0::UsersController < ApplicationController 
	def create
		user = User.new(user_params)
		if user
			if user.save
				render json: { data: user_data(user) }, status: :created
			else
				render json: { errors: user.errors.full_messages }, status: :unprocessable_entity
			end
		else
			render json: { error: "We could not find a valid user in the system"}, status: :unprocessable_entity
		end
	end

	def login
		user = User.find_by(email: request.params[:email])
		if user && user.authenticate
			render json: { data: user_data(user) }, status: 200
		else
			render json: { errors: user.errors.full_messages }, status: :unprocessable_entity
		end
	end

	private

	def user_params
		params.require(:user).permit(:email, :password, :password_confirmation)
	end 

	def user_data(user)
		{
			type: "users",
			id: user.id,
			attributes: {
				email: user.email,
				api_key: user.api_key
			}
		}
	end
end
