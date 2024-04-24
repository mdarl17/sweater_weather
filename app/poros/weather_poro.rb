class WeatherPoro
	attr_reader :id, :type, :location, :current_weather
	
	def initialize(location_attrs, current_attrs)
		@id = "null"
		@type = "forecast"
		@location = {
			name: location_attrs[:name],
			country: location_attrs[:country]
		}
		@current_weather = {
			last_updated: current_attrs[:last_updated],
			temperature: current_attrs[:temp_f],
			feels_like: current_attrs[:feels_like_f],
			humidity: current_attrs[:humidity],
			uvi: current_attrs[:uv],
			visibility: current_attrs[:vis_miles],
			condition: {
				text: current_attrs[:condition][:text],
				icon: current_attrs[:condition][:icon]
			}
		}
	end
end