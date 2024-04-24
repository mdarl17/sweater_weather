require "rails_helper"

RSpec.describe WeatherFacade, :vcr, type: :facade do 
	before(:each) do 
		@facade = WeatherFacade.new(q: "cleveland,oh", days: 5)
	end

	describe "#initialize" do 
		it "is instantiated with a new WeatherService instance, and given location and air quality attributes" do 
			expect(@facade).to be_a WeatherFacade
			expect(@facade.instance_variables).to match_array([:@service, :@location, :@days])
			expect(@facade.service).to be_a WeatherService
			expect(@facade.location).to be_a String
			expect(@facade.location).to eq("cleveland,oh")
		end
	end

	describe "#forecast" do 
		it "returns current weather data of a given location (city, state)" do
			expect(@facade.weather).to be_a WeatherPoro
			expect(@facade.weather.instance_variables).to match_array([:@current, :@daily_weather, :@hourly_weather, :@id, :@location, :@type])
			expect(@facade.weather.id).to eq("null")
			expect(@facade.weather.type).to eq("forecast")
			expect(@facade.weather.location.keys).to match_array([:city, :state, :country])
			expect(@facade.weather.location[:city]).to be_a String
			expect(@facade.weather.location[:state]).to be_a String
			expect(@facade.weather.location[:country]).to be_a String
			expect(@facade.weather.current).to be_a Hash
			expect(@facade.weather.current.keys).to match_array(
				[:last_updated, :temperature, :feels_like, :humidity, :uvi, :visibility, :condition]
			)
			expect(@facade.weather.current[:last_updated]).to be_a String
			expect(@facade.weather.current[:temperature]).to be_a Float
			expect(@facade.weather.current[:feels_like]).to be_nil.or be_a Float
			expect(@facade.weather.current[:humidity]).to be_an Integer
			expect(@facade.weather.current[:uvi]).to be_a Float
			expect(@facade.weather.current[:visibility]).to be_a Float
			expect(@facade.weather.current[:condition]).to be_a Hash
			expect(@facade.weather.current[:condition].keys).to match_array([:text, :icon])
			expect(@facade.weather.current[:condition][:text]).to be_a String
			expect(@facade.weather.current[:condition][:icon]).to be_a String
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