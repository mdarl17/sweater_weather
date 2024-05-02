require "rails_helper"

RSpec.describe WeatherFacade, :vcr, type: :facade do 
	before(:each) do 
		@loc_poro = LocationsFacade.new("Cleveland, OH").lat_lon
		
		lat = @loc_poro[:lat]
		lon = @loc_poro[:lng]
		lat_lon = "#{lat}, #{lon}"
		@facade = WeatherFacade.new(location: lat_lon, days: 5)
		@weather = @facade.weather
	end

	describe "#initialize" do 
		it "is instantiated with a new WeatherService instance, and given location and air quality attributes" do 
			expect(@facade).to be_a WeatherFacade
			expect(@facade.instance_variables).to match_array( [:@geo_coords, :@location, :@service])
			expect(@facade.service).to be_a WeatherService
			expect(@facade.location).to be_a Hash
			expect(@facade.location[:location]).to be_a String
			expect(@facade.location[:location]).to eq("41.50473, -81.69074")
			expect(@facade.location[:days]).to be_an Integer
			expect(@facade.location[:days]).to eq(5)
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
			expect(@weather.current_weather[:temperature]).to be_a String
			expect(@weather.current_weather[:feels_like]).to (be_nil).or (be_a String)
			expect(@weather.current_weather[:humidity]).to be_an Integer
			expect(@weather.current_weather[:uvi]).to be_a Float
			expect(@weather.current_weather[:visibility]).to be_a Float
			expect(@weather.current_weather[:condition]).to be_a Hash
			expect(@weather.current_weather[:condition].keys).to match_array([:text, :icon])
			expect(@weather.current_weather[:condition][:text]).to be_a String
			expect(@weather.current_weather[:condition][:icon]).to be_a String
		end
	end

	describe "#geo_coords" do 
		it "takes a city location and returns the latitude/longitude coordinates of that city" do 
			expect(WeatherFacade.new("Denver, CO").geo_coords).to be_a String
			expect(WeatherFacade.new("Denver, CO").geo_coords).to eq("39.74001,-104.99202")
		end
	end

	describe "#current_weather" do 
		it "given latitude and longitude of a location, it returns the current weather conditions of that location" do
			cw = WeatherFacade.new("Denver, CO").current_weather
			
			expect(WeatherFacade.new("Denver, CO").geo_coords).to eq("39.74001,-104.99202")
			expect(cw.keys).to eq([:location, :current])
			expect(cw[:location]).to be_a Hash
			expect(cw[:location].keys).to eq([:name, :region, :country, :lat, :lon, :tz_id, :localtime_epoch, :localtime])
			expect(cw[:location][:name]).to be_a String
			expect(cw[:location][:name]).to eq("Denver")
			expect(cw[:location][:region]).to be_a String
			expect(cw[:location][:region]).to eq("Colorado")
			expect(cw[:location][:country]).to be_a String
			expect(cw[:location][:country]).to eq("United States of America")
			expect(cw[:location][:lat]).to be_a Float
			expect(cw[:location][:lat]).to eq(39.74)
			expect(cw[:location][:lon]).to be_a Float
			expect(cw[:location][:lon]).to eq(-104.99)
			expect(cw[:location][:tz_id]).to be_a String
			expect(cw[:location][:tz_id]).to eq("America/Denver")
			expect(cw[:location][:localtime_epoch]).to be_an Integer
			expect(cw[:location][:localtime]).to be_a String
		end
	end
end 