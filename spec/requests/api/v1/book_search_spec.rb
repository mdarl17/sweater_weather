require "rails_helper"

RSpec.describe "Api::V1::book-search", :vcr, type: :request do 
	it "returns books that include the destination city provided" do
		get "/api/v1/book-search?location=denver,co&quantity=5"

		books = JSON.parse(response.body, symbolize_names: :true)

		expect(books[:data][:attributes][:books].count).to eq(5)
		expect(response).to be_successful
		expect(books[:data]).to have_key (:attributes)
		expect(books[:data]).to have_key (:id)
		expect(books[:data][:id]).to eq("null")
		expect(books[:data]).to have_key (:type)
		expect(books[:data][:attributes]).to be_a Hash
		expect(books[:data][:attributes]).to have_key(:books)
		expect(books[:data][:attributes][:books]).to be_an Array
		expect(books[:data][:attributes][:books].first).to have_key(:isbn)
		expect(books[:data][:attributes][:books].first[:isbn]).to be_an Array
		expect(books[:data][:attributes][:books].first).to have_key(:title)
		expect(books[:data][:attributes][:books].first[:title]).to be_a String
		expect(books[:data][:attributes][:books].first).to have_key(:publisher)
		expect(books[:data][:attributes][:books].first[:publisher]).to be_an Array
		expect(books[:data][:attributes][:books].first[:publisher].first).to be_a String
	end
end 