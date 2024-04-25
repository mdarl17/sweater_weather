class WeatherPoro
	attr_reader :id, :type, :current_weather, :daily_weather, :hourly_weather
	include ApplicationHelper
	
	def initialize(attrs)
		@id = "null"
		@type = "forecast"
		@current_weather = {
			last_updated: attrs[:real_time][:current][:last_updated],
			temperature: attrs[:real_time][:current][:temp_f],
			feels_like: attrs[:real_time][:current][:feels_like_f],
			humidity: attrs[:real_time][:current][:humidity],
			uvi: attrs[:real_time][:current][:uv],
			visibility: attrs[:real_time][:current][:vis_miles],
			condition: {
				text: attrs[:real_time][:current][:condition][:text],
				icon: attrs[:real_time][:current][:condition][:icon]
			}
		}
		@daily_weather = five_day_array(attrs[:daily]) if attrs[:daily]
		@hourly_weather = hourly_array(attrs[:hourly]) if attrs[:hourly]
	end

	def five_day_array(days_array)
		days_array.map do |d|
			{
				date: d[:date],
				sunrise: d[:astro][:sunrise],
				sunset: d[:astro][:sunset],
				max_temp: d[:day][:maxtemp_f],
				min_temp: d[:day][:mintemp_f],
				condition: d[:day][:condition][:text],
				icon: d[:day][:condition][:icon]
			}
		end
	end

	def hourly_array(hours_array)
		hours_array.map do |h|
			{
				time: h[:time].split(" ").second,
				temperature: h[:temp_f],
				conditions: h[:condition][:text],
				icon: h[:condition][:icon]
			}
		end
	end

	def get_state_code(state)
		code = us_states.find do |name_code|
			state == name_code[0]
		end
		code[1]
	end
end