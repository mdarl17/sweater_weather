class Api::V0::LocationsController < ApplicationController
	def search
		facade = LocationsFacade.new(params[:location])
		result = facade.lat_lon
			raise ArgumentError, "A valid location must be provided" if params[:location].scan(/\d/).length > 0
			# raise SecurityError, "The user's email was not included in this request" unless current_user && params[:email] == current_user.email
			raise SecurityError, "The user's api_key was not included in this request" unless params[:api_key] == current_user.api_key
			render json: { "lat": result[:lat], "lon": result[:lng] } 
		end
	end