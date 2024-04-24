require "rails_helper"
require_relative "../../app/helpers/application_helper"

RSpec.describe WeatherPoro, :vcr, type: :poro do 
	include ApplicationHelper
	it "exists" do
		wf = WeatherFacade.new(q: "Cleveland, OH", days: 5)

		forecast_poro = wf.weather
		expect(forecast_poro).to be_a WeatherPoro
	end
end