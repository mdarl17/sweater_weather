class LocationsFacade
	def initialize(location)
		@service = LocationsService.new
		@location = location
	end
	
	def lat_lon
		response = @service.get_geo_data(@location)
		coords = response[:results].first[:locations].first[:latLng]
		coords
	end
end