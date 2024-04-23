class WeatherSerializer
	include JSONAPI::Serializer

	attributes :id, :current_weather

	set_type :forecast
end