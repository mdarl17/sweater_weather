class Api::V0::RoadTripsController < ApplicationController
	def index
		facade = RoadTripsFacade.new(origin: params[:origin], destination: params[:destination], api_key: params[:api_key])
		road_trip = facade.trip_details

		render json: {
			data: {
				id: "null",
				type: "road_trip",
				attributes: [
					road_trip
				]
			}
		}
	end
end