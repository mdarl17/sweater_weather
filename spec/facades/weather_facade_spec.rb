require "rails_helper"

RSpec.describe WeatherFacade, :vcr, type: :facade do 
	before(:each) do 
		@loc_poro = LocationsFacade.new("Cleveland, OH").lat_lon
		lat = @loc_poro.latlon[:lat]
		lon = @loc_poro.latlon[:lng]
		lat_lon = "#{lat}, #{lon}"
		@facade = WeatherFacade.new(q: lat_lon, days: 5)
		@weather = @facade.weather
	end

	describe "#initialize" do 
		it "is instantiated with a new WeatherService instance, and given location and air quality attributes" do 
			expect(@facade).to be_a WeatherFacade
			expect(@facade.instance_variables).to match_array([:@service, :@location, :@days])
			expect(@facade.service).to be_a WeatherService
			expect(@facade.location).to be_a String
			expect(@facade.location).to eq("41.50473, -81.69074")
		end
	end

	describe "#forecast" do 
		it "returns current weather data of a given location (city, state)" do
			expect(@weather).to be_a WeatherPoro
			expect(@weather.instance_variables).to match_array([:@current_weather, :@daily_weather, :@hourly_weather, :@id, :@type])
			expect(@weather.id).to eq("null")
			expect(@weather.type).to eq("forecast")
			expect(@weather.current_weather).to be_a Hash
			expect(@weather.current_weather.keys).to match_array(
				[:last_updated, :temperature, :feels_like, :humidity, :uvi, :visibility, :condition]
			)
			expect(@weather.current_weather[:last_updated]).to be_a String
			expect(@weather.current_weather[:temperature]).to be_a Float
			expect(@weather.current_weather[:feels_like]).to be_nil.or be_a Float
			expect(@weather.current_weather[:humidity]).to be_an Integer
			expect(@weather.current_weather[:uvi]).to be_a Float
			expect(@weather.current_weather[:visibility]).to be_a Float
			expect(@weather.current_weather[:condition]).to be_a Hash
			expect(@weather.current_weather[:condition].keys).to match_array([:text, :icon])
			expect(@weather.current_weather[:condition][:text]).to be_a String
			expect(@weather.current_weather[:condition][:icon]).to be_a String
		end
	end

	describe "#make_weather_poro" do 
		it "converts a weather data hash into a ruby object (of class WeatherPoro)" do 
			expect(@facade).to be_a WeatherFacade
			weather_data = @facade.weather
			expect(weather_data).to be_a WeatherPoro
		end
	end
end 