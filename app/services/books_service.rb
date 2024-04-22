class BooksService
	def books_search(location="", quantity=20)
		get_url("/search.json?q=#{location}&limit=#{quantity}")
	end

	def get_url(url)
		response = conn.get(url)
		JSON.parse(response.body, symbolize_names: true)
	end

	def conn
		Faraday.new(url: "https://openlibrary.org") do |f|
			f.headers["Content-Type"] = "application/json"
		end
	end
end