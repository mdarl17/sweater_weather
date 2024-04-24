class Api::V0::LocationsController < ApplicationController
	def search
		facade = LocationsFacade.new(params[:location])
		result = facade.lat_lon

		render json: { "location": params[:location], "lat": result.latlon[:lat], "lon": result.latlon[:lng] }
	end
end