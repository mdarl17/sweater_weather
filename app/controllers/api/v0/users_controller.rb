class Api::V0::UsersController < ApplicationController 
	def create
		user = User.new(user_params)
		user.generate_api_key
		if user.authenticate(user_params[:password]) && user.save
			render json: { data: user_data(user) }, status: 201
		elsif user.errors[:password].include?("doesn't match Password")
			render json: { error: "A valid email and password is required" }
		elsif user.errors[:email].include?("can't be blank")
			render json: { error: "Please provide a valid email address" }, status: :bad_request
		elsif user.errors[:email].include?("has already been taken")
			render json: { error: "The email provided is already linked with an account" }, status: :bad_request
		elsif user.errors[:email].include?("format is invalid")
			render json: { error: "A valid email and password is required" }, status: :bad_request
		else
			render json: { error: "A valid email and password is required" }, status: :bad_request
		end
	end

	def login
		user = User.find_by(email: params[:email])
		if user.present?
			if user.authenticate(params[:password])
				render json: { data: user_data(user) }, status: 200
			elsif !user.authenticate(params[:password])
				render json: { error: "Valid email and password are required" }
			elsif user.errors[:email].include?("can't be blank")
				render json: { error: "Email can't be blank" }, status: 
			elsif user.errors[:email].include?("doesn't match email")
				render json: { error: "Valid email and password are required" }
			elsif user.errors[:password].include?("doesn't match Password")
				render json: { error: "Valid email and password are required" }
			elsif user.errors[:password].include?("can't be blank")
				render json: { error: "Password can't be blank" }
			else
				render json: { error: "There was a problem validating the email or password provided."}
			end
		else
			render json: { error: "User credential error: We could not find a user with the email/username combination used." }
		end
	end

	private

	def user_params
		params.require(:user).permit(:email, :password, :password_confirmation, :api_key)
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
