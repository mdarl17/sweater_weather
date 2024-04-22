class Api::V1::BooksController < ApplicationController
	def search
		facade = BooksFacade.new
		books = facade.books(params[:location], params[:quantity])
		render json: BookSerializer.new(books)
	end
end