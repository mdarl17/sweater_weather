class BooksFacade
	def books(location, quantity)
		service = BooksService.new
		book_data = service.books_search(location, quantity)
		book_poro(book_data)
	end

	def book_poro(book_data)
		BookPoro.new(book_data)
	end
end