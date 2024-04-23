require "rails_helper"

RSpec.describe BooksFacade, :vcr, type: :facade do 
	before(:each) do 
		@facade = BooksFacade.new	
	end

	describe "#books" do 
		it "returns the first n (default is 5) results - as plain ruby objects - of a book search given a location" do 
			expect(@facade.books("denver,co", 5)).to be_a BookPoro
			expect(@facade.books("denver,co", 5).total_books_found).to be_an Integer
			expect(@facade.books("denver,co", 5).total_books_found).to eq(745)
			expect(@facade.books("denver,co", 5).books.count).to eq(5)
			expect(@facade.books("denver,co", 5).books).to be_an Array
			expect(@facade.books("denver,co", 5).books.first.keys).to match_array([:isbn, :title, :publisher])
			expect(@facade.books("denver,co", 5).books.first[:isbn]).to match_array(["0762507845", "9780762507849"])
			expect(@facade.books("denver,co", 5).books.first[:title]).to be_a String
			expect(@facade.books("denver,co", 5).books.first[:title]).to eq("Denver, Co")
			expect(@facade.books("denver,co", 5).books.first[:publisher]).to be_an Array
			expect(@facade.books("denver,co", 5).books.first[:publisher]).to eq(["Universal Map Enterprises"])
			expect(@facade.books("denver,co", 5).books.first[:publisher].first).to be_a String
		end
	end
end 