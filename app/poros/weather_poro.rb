class WeatherPoro
	attr_reader :id, :type, :current_weather, :daily_weather, :hourly_weather
	include ApplicationHelper
	
	def initialize(attrs)
		@id = "null"
		@type = "forecast"
		@current_weather = current_array(attrs[:real_time]) if attrs[:real_time]
		@daily_weather = five_day_array(attrs[:daily]) if attrs[:daily]
		@hourly_weather = hourly_array(attrs[:hourly]) if attrs[:hourly]
	end

	def current_array(attrs)
		{
			last_updated: attrs[:current][:last_updated],
				temperature: attrs[:current][:temp_f],
				feels_like: "#{attrs[:current][:feelslike_f]}°F",
				humidity: attrs[:current][:humidity],
				uvi: attrs[:current][:uv],
				visibility: attrs[:current][:vis_miles],
				condition: {
					text: attrs[:current][:condition][:text],
					icon: attrs[:current][:condition][:icon]
				}
			}
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

		hours_array.map do |day_array|
			day_array.map do |d|
				{
					time: "#{Time.parse(d[:time]).strftime("%-l:%M")}#{am_or_pm(Time.parse(d[:time]).hour)}",
					temperature: "#{d[:temp]}°F",
					condition: d[:condition].strip,
				}
			end
		end
	end

	def am_or_pm(hour)
		hour < 12 ? "AM" : "PM"
	end

	def get_state_code(state)
		code = us_states.find do |name_code|
			state == name_code[0]
		end
		code[1]
	end
end