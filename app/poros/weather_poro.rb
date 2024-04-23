class WeatherPoro
	attr_reader :id, :type, :current_weather
	
	def initialize(attributes)
		@id = "null"
		@type = "forecast"
		@current_weather = {
			last_updated: attributes[:last_updated],
			temperature: attributes[:temp_f],
			feels_like: attributes[:feels_like_f],
			humidity: attributes[:humidity],
			uvi: attributes[:uv],
			visibility: attributes[:vis_miles],
			condition: {
				text: attributes[:condition][:text],
				icon: attributes[:condition][:icon]
			}
		}
	end
end