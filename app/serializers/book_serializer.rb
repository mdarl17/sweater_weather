class BookSerializer
	include JSONAPI::Serializer

	attributes :id, :type, :total_books_found, :books
end