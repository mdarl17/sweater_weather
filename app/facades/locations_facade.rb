class LocationsFacade
	def initialize(location="")
		@service = LocationsService.new
		@location = location 
	end

	def lat_lon
		response = @service.get_geo_data(@location)
		make_location_poro(response)
	end

	# TODO??
	# Thought re-formatting 'user' input would create more consistency in searches?
	# Wanted something short though; multiple chains perhaps? Started getting out of hand
	# and realized how many different scenarios to account for => I do know that the project
	# reqs said we could assume users were always entering valid input. I get why that was
	# included in the project reqs, but it isn't very practical, obviously. Hoping to get
	# better at making my own fix-its and helpers I gave it a shot. I'm sure I could come up 
	# with something but I don't have the time right now.
	
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