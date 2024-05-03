require "rails_helper"

RSpec.describe WeatherFacade, :vcr, type: :facade do 
	before(:each) do
		@loc_coords = LocationsFacade.new("Cleveland, OH").lat_lon
		lat = @loc_coords[:lat]
		lon = @loc_coords[:lng]
		lat_lon = "#{lat}, #{lon}"
		@facade = WeatherFacade.new(lat_lon, 5)
		@weather = @facade.weather
	end

	describe "#initialize" do 
		it "exists" do
			expect(@facade).to be_a WeatherFacade
			expect(@facade.instance_variables).to match_array([:@location, :@service, :@days])
			expect(@facade.service).to be_a WeatherService
			expect(@facade.location).to be_a String
			expect(@facade.location).to be_a String
			expect(@facade.location).to eq("41.50473, -81.69074")
			expect(@facade.days).to be_an Integer
			expect(@facade.days).to eq(5)
		end
	end

	describe "WeatherFacade Attributes" do
		it "has some fixed attributes" do
			expect(@weather).to be_a WeatherPoro
			expect(@weather.instance_variables).to match_array([:@current_weather, :@daily_weather, :@hourly_weather, :@id, :@type])
			expect(@weather.id).to eq("null")
			expect(@weather.type).to eq("forecast")
		end
	end

	describe "#current_weather" do 
		it "given latitude and longitude of a location, it returns the current weather conditions of that location" do
			lf = LocationsFacade.new("Denver, CO").lat_lon
			lat_lon = "#{lf[:lat]},#{lf[:lng]}"
			wf = WeatherFacade.new(lat_lon, 5)
			cw = wf.current_weather

			expect(cw).to be_a Hash
			expect(cw.keys).to eq([:location, :current])

			expect(cw[:current][:last_updated]).to be_a String
			expect(cw[:current][:temp_f]).to be_a Float
			expect(cw[:current][:feelslike_f]).to be_a Float
			expect(cw[:current][:humidity]).to be_an Integer
			expect(cw[:current][:uv]).to be_a Float
			expect(cw[:current][:vis_miles]).to be_a Float
			expect(cw[:current][:condition]).to be_a Hash
			expect(cw[:current][:condition].keys).to eq([:text, :icon, :code])
			expect(cw[:current][:condition][:text]).to be_a String
			expect(cw[:current][:condition][:icon]).to be_a String
			expect(cw[:current][:condition][:code]).to be_an Integer
			expect(cw[:current][:last_updated]).to be_a String

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

	describe "#daily_weather" do 
		it "returns weather forecasts for the number of days requested (default is 5 days)" do
			lf = LocationsFacade.new("Louisville, KY").lat_lon
			lat_lon = "#{lf[:lat]},#{lf[:lng]}"
			wf = WeatherFacade.new(lat_lon)
			dw = wf.daily_weather
			dw_10 = wf.daily_weather(10)
			
			expect(dw.count).to eq(5)
			expect(dw_10.count).to eq(10)

			expect(dw.first.keys).to eq([:date, :date_epoch, :day, :astro, :hour])

			expect(dw[0][:date].split("-").first.length).to eq(4)
			expect(dw[0][:date].split("-").first.to_i).to be_an Integer
			# expect(dw[1][:date]).to eq((Time.now + 1*24*3600).strftime("%Y-%m-%d"))
			# expect(dw[2][:date]).to eq((Time.now + 2*24*3600).strftime("%Y-%m-%d"))
			# expect(dw[3][:date]).to eq((Time.now + 3*24*3600).strftime("%Y-%m-%d"))
			# expect(dw[4][:date]).to eq((Time.now + 4*24*3600).strftime("%Y-%m-%d"))

			expect(dw[0][:hour].count).to eq(24)
			expect(dw[0][:hour].first).to include(:condition)

			expect(dw[0][:day][:maxtemp_f]).to be_a Float
			expect(dw[0][:day][:mintemp_f]).to be_a Float
			expect(dw[0][:day][:avgtemp_f]).to be_a Float
		end
	end

	describe "#hourly_weather" do 
		it "returns the weather forecast for every hour for a given number of days (default is 5 days)" do
			lf = LocationsFacade.new("Louisville, KY").lat_lon
			lat_lon = "#{lf[:lat]},#{lf[:lng]}"
			wf = WeatherFacade.new(lat_lon, 5)
			hw = wf.hourly_weather
			hw_10 = wf.hourly_weather(10)

			expect(hw.count).to eq(5)
			expect(hw_10.count).to eq(10)

			expect(hw.first.count).to eq(24)
			expect(hw.sample.sample.keys).to eq([:date, :time, :temp, :condition])
			expect(hw.sample.sample[:date]).to be_a String
			expect(hw.sample.sample[:time]).to be_a String
			expect(hw.sample.sample[:temp]).to be_a Float
			expect(hw.sample.sample[:condition]).to be_a String
		end
	end

	describe "#weather" do 
		it "returns curren, hourly, and daily weather forecasts together" do
			lf = LocationsFacade.new("New York, NY").lat_lon
			lat_lon = "#{lf[:lat]},#{lf[:lng]}"
			wf = WeatherFacade.new(lat_lon, 3)
			weather = wf.weather

			expect(weather).to be_a WeatherPoro
			expect(weather.instance_variables).to eq([:@id, :@type, :@current_weather, :@daily_weather, :@hourly_weather])
			expect(weather.current_weather.keys).to eq([:last_updated, :temperature, :feels_like, :humidity, :uvi, :visibility, :condition])
			expect(weather.daily_weather).to be_an Array
			expect(weather.daily_weather.count).to eq(3)
			expect(weather.daily_weather.first).to be_a Hash
			expect(weather.daily_weather.first.keys).to eq([:date, :sunrise, :sunset, :max_temp, :min_temp, :condition, :icon])
			expect(weather.hourly_weather).to be_an Array
			expect(weather.hourly_weather.count).to eq(72) # 24 hrs * 3 days
			expect(weather.hourly_weather.first).to be_a Hash
			expect(weather.hourly_weather.first.keys).to eq([:date, :time, :temperature, :condition])
			expect(weather.hourly_weather.first[:date]).to be_a String
			expect(weather.hourly_weather.first[:time]).to be_a String
			expect(weather.hourly_weather.first[:temperature]).to be_a String
			expect(weather.hourly_weather.first[:temperature]).to include("°F")
			expect(weather.hourly_weather.first[:condition]).to be_a String
		end
	end
end 