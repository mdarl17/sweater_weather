class WeatherSerializer
	include JSONAPI::Serializer

	attributes :id, :current_weather, :location

	set_type :forecast
end