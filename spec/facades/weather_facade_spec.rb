require "rails_helper"

RSpec.describe WeatherFacade, :vcr, type: :facade do 
	before(:each) do 
		@facade = WeatherFacade.new(q: "cleveland,oh", aqi: false)
	end

	describe "#initialize" do 
		it "is instantiated with a new WeatherService instance, and given location and air quality attributes" do 
			expect(@facade).to be_a WeatherFacade
			expect(@facade.instance_variables).to match_array([:@service, :@location, :@air_quality])
			expect(@facade.service).to be_a WeatherService
			expect(@facade.location).to be_a String
			expect(@facade.location).to eq("cleveland,oh")
			expect(@facade.air_quality).to be_a FalseClass
			expect(@facade.air_quality).to eq(false)
		end
	end

	describe "#forecast" do 
		it "returns current weather data of a given location (city, state)" do
			expect(@facade.forecast).to be_a WeatherPoro
			expect(@facade.forecast.instance_variables).to match_array([:@id, :@type, :@location, :@current_weather])
			expect(@facade.forecast.id).to eq("null")
			expect(@facade.forecast.type).to eq("forecast")
			expect(@facade.forecast.location.keys).to match_array([:name, :country])
			expect(@facade.forecast.location[:name]).to be_a String
			expect(@facade.forecast.location[:country]).to be_a String
			expect(@facade.forecast.current_weather).to be_a Hash
			expect(@facade.forecast.current_weather.keys).to match_array(
				[:last_updated, :temperature, :feels_like, :humidity, :uvi, :visibility, :condition]
			)
			expect(@facade.forecast.current_weather[:last_updated]).to be_a String
			expect(@facade.forecast.current_weather[:temperature]).to be_a Float
			expect(@facade.forecast.current_weather[:feels_like]).to be_nil.or be_a Float
			expect(@facade.forecast.current_weather[:humidity]).to be_an Integer
			expect(@facade.forecast.current_weather[:uvi]).to be_a Float
			expect(@facade.forecast.current_weather[:visibility]).to be_a Float
			expect(@facade.forecast.current_weather[:condition]).to be_a Hash
			expect(@facade.forecast.current_weather[:condition].keys).to match_array([:text, :icon])
			expect(@facade.forecast.current_weather[:condition][:text]).to be_a String
			expect(@facade.forecast.current_weather[:condition][:icon]).to be_a String
		end
	end

	describe "#make_weather_poro" do 
		it "converts a weather data hash into a ruby object (of class WeatherPoro)" do 
			expect(@facade).to be_a WeatherFacade
			weather_data = @facade.forecast
			expect(weather_data).to be_a WeatherPoro
		end
	end
end 