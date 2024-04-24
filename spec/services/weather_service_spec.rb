require "rails_helper"

RSpec.describe "Weather Service", :vcr, type: :service do 
	before(:each) do 
		@service = WeatherService.new
  end

	describe "#get_forecast" do 
		it "returns current weather data for a given location" do
			location = "los angeles, ca"
			aqi = false
			weather_data = @service.get_forecast(location: location, air_quality: aqi)
			expect(weather_data).to be_a Hash
			expect(weather_data.keys).to match_array([:location, :current])
			expect(weather_data[:location]).to be_a Hash
			expect(weather_data[:current]).to be_a Hash
			expect(weather_data[:location].keys).to match_array(
				[:name, :region, :country, :lat, :lon, :tz_id, :localtime_epoch, :localtime]
			)
			expect(weather_data[:current].keys).to match_array(
				[:last_updated_epoch,:last_updated,:temp_c,:temp_f,:is_day,:condition,
					:wind_mph,:wind_kph,:wind_degree,:wind_dir,:pressure_mb,:pressure_in,
					:precip_mm,:precip_in,:humidity,:cloud,:feelslike_c,:feelslike_f,:vis_km,
					:vis_miles,:uv,:gust_mph,:gust_kph
				]
			)
		end
	end
end 