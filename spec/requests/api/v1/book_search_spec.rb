require "rails_helper"

RSpec.describe "Api::V1::book-search", :vcr, type: :request do 
	before(:each) do 
		def @conn(slug, options)
			Faraday.get(slug) do |f|
				f.header["Content-Type"] = "application/json"
				f.header["Accept"] = "*/*"
				f.params[:options] = options
			end
		end
	end
	it "returns books that include the destination city provided" do
		location = "Denver, CO"
		weather_loc_formatted = location.downcase.delete(" ")
		air_quality = false
		weather_url = "https://api.weatherapi.com/v1/current.json?q=#{weather_loc_formatted}&aqi=#{air_quality}"

		def conn(url)
			Faraday.new(url: "https://api.weatherapi.com/v1/current.json?q=#{weather_loc_formatted}&aqi=#{air_quality}")
		end

		def weather_request(location="London, England", air_quality=false)
			response = conn("https://api.weatherapi.com/v1/current.json?q=#{weather_loc_formatted}&aqi=#{air_quality}")
		end

		get "/api/v1/weather"
		https://api.weatherapi.com/v1/current.json?q=London&aqi=no

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