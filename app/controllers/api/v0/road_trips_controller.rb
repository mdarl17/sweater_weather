class Api::V0::RoadTripsController < ApplicationController
	def index
		from = params[:from]
		to = params[:to]

		response = RoadTripsService.new.get_travel_time(from, to)
		duration = response[:route][:formattedTime]

		def dest_time(duration)
			t1 = Time.parse(duration)
			Time.now + t1.hour * 3600 + t1.min * 60
		end

		dest_weather = WeatherFacade.new(q: from).weather.hourly_weather[dest_time(duration).hour]

		road_trip = {
			from: params[:from],
			to: params[:to],
			trip_time: duration,
			arrival_weather: "#{dest_weather[:temperature]}, #{dest_weather[:conditions]}"
		}

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