class Api::V0::LocationsController < ApplicationController
	def search
		facade = LocationsFacade.new(params[:location])
		result = facade.lat_lon

		if result[:lat] && result[:lng]
			render json: { "lat": result[:lat], "lon": result[:lng] }
		elsif !result[:lat]
			render json: { error: "Could not find latitude value for #{params[:location]}" }
		elsif !result[:lng]
			render json: { error: "Could not find longitude value for #{params[:location]}" }
		elsif params[:api_key].errors.include?("doesn't match API key")
			render json: { error: "API key validation error: API key provided does not match the API key on file" }
		elsif params[:api_key].errors.include?("can't be blank")
			render json: { error: "A valid API key must be included in the request params"}
		else
			render json: { error: "A validation error occurred. Please check spelling and try again."}
		end
	end
end