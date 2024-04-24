class LocationSerializer
	include JSONAPI::Serializer

	attributes :id, :latlon, :formatted_location
end