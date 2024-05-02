class LocationsFacade
	def initialize(location)
		@service = LocationsService.new
		@location = location
	end
	
	def lat_lon
		if @location.class == String
			response = @service.get_geo_data(@location)
		elsif @location.class == Hash
			response = @service.get_geo_data(@location[:location])
		end
		coords = response[:results].first[:locations].first[:latLng]
		coords
	end
end