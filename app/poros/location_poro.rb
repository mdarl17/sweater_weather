class LocationPoro
	attr_reader :id, :latlon, :city_state
	def initialize(attributes)
		@id = "null"
		@type = "geocoding"
		@latlon = attributes.first[:locations].first[:latLng]
		@location = attributes.first[:providedLocation][:location]
	end
end