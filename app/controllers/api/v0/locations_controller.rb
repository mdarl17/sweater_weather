class Api::V0::LocationsController < ApplicationController
	def search
		facade = LocationsFacade.new(params[:q])
		result = facade.lat_lon

		render json: { "location": params[:q], "lat": result.latlon[:lat], "lon": result.latlon[:lng] }
	end
end