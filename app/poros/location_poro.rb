class LocationPoro
	attr_reader :id, :latlon, :city_state
	def initialize(attributes)
		@id = "null"
		@type = "geocoding"
		# @lat_lon = attributes.first[:providedLocation][:latLng]
	end
end