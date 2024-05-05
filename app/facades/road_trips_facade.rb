class RoadTripsFacade
	def initialize(trip_params)
		@origin = trip_params[:origin]
		@destination = trip_params[:destination]
		@duration = route_hash[:route][:formattedTime]
		dest_coords = LocationsFacade.new(@destination).lat_lon
		dest_latlon = "#{dest_coords[:lat]}, #{dest_coords[:lng]}"
		origin_coords = LocationsFacade.new(@origin).lat_lon
		origin_latlon = "#{origin_coords[:lat]}, #{origin_coords[:lng]}"
		@dest_time = WeatherFacade.new(dest_latlon).current_weather[:location][:localtime].split(" ").second
		@origin_time = WeatherFacade.new(origin_latlon).current_weather[:location][:localtime].split(" ").second
		@trip_time_hours = @duration.split(":").first.to_i
		@trip_time_minutes = @duration.split(":").second.to_i
		@round_hour = @trip_time_minutes >= 30 ? 1 : 0
	end

	def route_hash
		RoadTripsService.new(@origin, @destination).get_travel_time
	end

	def index
		RoadTripsService.new(@origin, @destination).get_travel_time
	end

	def trip_time_in_seconds
		dur_array = @duration.split(":")
		hrs_to_sec = dur_array.first.to_i * 3600
		min_to_sec = dur_array.second.to_i * 60
		sec = dur_array.third.to_i
		total_sec = hrs_to_sec + min_to_sec + sec
		total_sec
	end

	def time_zone_offset
		@dest_time.split(":").first.to_i - @origin_time.split(":").first.to_i
	end

	def get_eta
		arrive_time = Time.now + trip_time_in_seconds + @round_hour * 3600 + time_zone_offset * 3600
		arrive_time
	end

	def dest_weather
		@trip_time_minutes = @duration.split(":").second.to_i

		hourly_forecast = WeatherFacade.new(@destination).hourly_weather(5)
		hourly_forecast.flatten[Time.now.hour + @trip_time_hours + @round_hour.to_i]
	end

	def trip_details
		{
			estimated_arrival: get_eta.strftime("%A, %b %d %-l:%M%p"),
			estimated_temp: "#{dest_weather[:temp]}°f",
			estimated_condition: dest_weather[:condition].strip,
			trip_time: "#{@trip_time_hours} hrs, #{@trip_time_minutes} min"
		}
	end
end