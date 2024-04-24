class WeatherSerializer
	include JSONAPI::Serializer

	attributes :id, :type, :location, :current, :daily_weather, :hourly_weather
	set_type :forecast
end