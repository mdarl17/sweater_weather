class LocationsFacade
	def initialize(location="")
		@service = LocationsService.new
		@location = location 
	end

	def lat_lon
		response = @service.get_geo_data(@location)
		make_location_poro(response)
	end

	# 	l_array = @location.split(",").flat_map do |l|
	# 		arr = l.split(" ")
	# 		if arr.count > 0
	# 			arr.flat_map(&:capitalize)
	# 		end
	# 	end
	# 	l_array.join(" ")
	# end

	def make_location_poro(geo_data)
		LocationPoro.new(geo_data[:results])
	end
end