# require "helpers/application_helper"

class WeatherPoro
	attr_reader :id, :type, :location, :current, :daily_weather, :hourly_weather
	include ApplicationHelper
	
	def initialize(attrs)
		@id = "null"
		@type = "forecast"
		@location = {
			lat: attrs[:geocoding].latlon[:lat],
			lon: attrs[:geocoding].latlon[:lng],
			city: attrs[:location][:name],
			state: get_state_code(attrs[:location][:region]),
			country: attrs[:location][:country].include?("United States") ? 
				"United States" : 
				attrs[:location][:country]
		}
		@current = {
			last_updated: attrs[:current][:last_updated],
			temperature: attrs[:current][:temp_f],
			feels_like: attrs[:current][:feels_like_f],
			humidity: attrs[:current][:humidity],
			uvi: attrs[:current][:uv],
			visibility: attrs[:current][:vis_miles],
			condition: {
				text: attrs[:current][:condition][:text],
				icon: attrs[:current][:condition][:icon]
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