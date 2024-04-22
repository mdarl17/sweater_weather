class BookPoro
	attr_reader :id, :type, :total_books_found, :books
	
	def initialize(book_data)
		@id = "null"
		@type = "books"
		@total_books_found = book_data[:numFound]
		@books = iterate_books(book_data[:docs])
	end

	def iterate_books(books)
		books.map do |book|
			{ 
				isbn: book[:isbn],
				title: book[:title],
				publisher: book[:publisher]
			}
		end
	end
end