require "rails_helper"

RSpec.describe "Locations Facade", type: :type do 
	before(:each) do 
		@lf = LocationsFacade.new("Las Vegas, NV")
	end
	describe "#lat_lon" do 
		it "returns the latitude and longitude values of a given location" do 
			expect(@lf.lat_lon).to eq({lat: 36.17193, lng: -115.14001})
		end
	end
end 