require "rails_helper"

RSpec.describe BooksService, :vcr, type: :facade do 
	before(:each) do 
		@service = BooksService.new	
	end

	describe "#books_search" do 
		it "finds all books that match the provided location, and displays the first `n' results" do
			cleveland_books = @service.books_search("cleveland,oh", 5)
			expect(cleveland_books).to be_a Hash
			expect(cleveland_books[:docs]).to be_an Array
			expect(cleveland_books[:docs].count).to eq(5)
			expect(cleveland_books.keys).to match_array([:numFound, :start, :numFoundExact, :num_found, :docs, :q, :offset])
			expect(cleveland_books[:numFound]).to be_an Integer
			expect(cleveland_books[:numFound]).to eq(98)
			expect(cleveland_books[:start]).to be_an Integer
			expect(cleveland_books[:start]).to eq(0)
			expect(cleveland_books[:numFoundExact]).to be_a TrueClass
			expect(cleveland_books[:numFoundExact]).to eq(true)
			expect(cleveland_books[:q]).to be_a String
			expect(cleveland_books[:q]).to eq("cleveland,oh")
		end
	end
end 