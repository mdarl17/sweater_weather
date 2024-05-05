require "rails_helper"
require_relative "../../app/helpers/application_helper"

RSpec.describe WeatherPoro, :vcr, type: :poro do 
	include ApplicationHelper
	it "exists" do
		lf = LocationsFacade.new("Cleveland, OH").lat_lon
		latlon = "#{lf[:lat]},#{lf[:lng]}"
		wf = WeatherFacade.new(latlon, 5)

		weather_poro = wf.weather
		expect(weather_poro).to be_a WeatherPoro
	end
end