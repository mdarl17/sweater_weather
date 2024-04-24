require "rails_helper"

RSpec.describe WeatherPoro, type: :poro do 
	it "exists" do
		attrs =	{
			"location": {
				"name": "Cincinnati",
				"region": "Ohio",
				"country": "United States of America",
				"lat": 39.16,
				"lon": -84.46,
				"tz_id": "America/New_York",
				"localtime_epoch": 1713922977,
				"localtime": "2024-04-23 21:42"
			},
			"current": {
				"last_updated_epoch": 1713922200,
				"last_updated": "2024-04-23 21:30",
				"temp_c": 13.3,
				"temp_f": 55.9,
				"is_day": 0,
				"condition": {
					"text": "Light rain",
					"icon": "//cdn.weatherapi.com/weather/64x64/night/296.png",
					"code": 1183
				},
				"wind_mph": 12.5,
				"wind_kph": 20.2,
				"wind_degree": 280,
				"wind_dir": "W",
				"pressure_mb": 1014.0,
				"pressure_in": 29.94,
				"precip_mm": 3.48,
				"precip_in": 0.14,
				"humidity": 84,
				"cloud": 100,
				"feelslike_c": 11.5,
				"feelslike_f": 52.8,
				"vis_km": 14.0,
				"vis_miles": 8.0,
				"uv": 1.0,
				"gust_mph": 19.2,
				"gust_kph": 30.9
			}
		}
		forecast_poro = WeatherPoro.new(attrs[:location], attrs[:current])
		expect(forecast_poro).to be_a WeatherPoro
	end
end 