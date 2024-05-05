require "rails_helper"

RSpec.describe "Get geo data", :vcr, type: :request do
	before(:each) do 
		@user = User.create!(email: "mattyd@turing.edu", password: "pass123", password_confirmation: "pass123", api_key: SecureRandom.hex(13))
		# @user2 = User.create!(email: "juneau@dognapz.com", password: "woof123", password_confirmation: "woof123", api_key: SecureRandom.hex(13))
	end

	describe "Api::V0::Location" do 

		# happy path
		it "it returns latitude and longitude data for a given city, state, or region" do
			get "/api/v0/locations", headers: {"Content-Type": "application/json", "Accept": "application/json "}, 
					params: { location: "cincinnati,oh", email: @user.email, api_key: @user.api_key}

			parsed = JSON.parse(response.body, symbolize_names: true)
			expect(response).to have_http_status(200)
			expect(response.body).to be_a String
			expect(parsed).to be_a Hash
			expect(parsed).to eq({:lat=>39.10713, :lon=>-84.50413})
		end

		# sad path
			# invalid latitude
			it "will return an ArgumentError if the location provided includes any numbers" do
				get "/api/v0/locations", headers: {"Content-Type": "application/json", "Accept": "application/json "}, 
						params: { location: "abc123", email: @user.email, api_key: @user.api_key }
						
				parsed = JSON.parse(response.body, symbolize_names: true)
				expect(response).to have_http_status(400)
				expect(response.body).to be_a String
				expect(parsed).to be_a Hash
				expect(parsed).to eq(error: "A valid location must be provided")

				get "/api/v0/locations", headers: {"Content-Type": "application/json", "Accept": "application/json "}, 
					params: { location: "123", email: @user.email, api_key: @user.api_key }

				parsed = JSON.parse(response.body, symbolize_names: true)
				expect(response).to have_http_status(400)
				expect(response.body).to be_a String
				expect(parsed).to be_a Hash
				expect(parsed).to eq(error: "A valid location must be provided")
			end

		# sad path
			# missing API key
		it "it will return an ArgumentError if the API key is missing" do
			get "/api/v0/locations", headers: {"Content-Type": "application/json", "Accept": "application/json "}, 
					params: { location: "cincinnati,oh", email: @user.email, api_key: " " }
					
			parsed = JSON.parse(response.body, symbolize_names: true)
			expect(response).to have_http_status(401)
			expect(response.body).to be_a String
			expect(parsed).to be_a Hash
			expect(parsed).to eq(error: "The user's api_key was not included in this request")
		end

		# sad path
			# missing email
		it "it will return an ArgumentError if the email is missing" do
			get "/api/v0/locations", headers: {"Content-Type": "application/json", "Accept": "application/json "}, 
					params: { location: "cincinnati,oh", email: " ", api_key: @user.api_key }
					
			parsed = JSON.parse(response.body, symbolize_names: true)
			expect(response).to have_http_status(401)
			expect(response.body).to be_a String
			expect(parsed).to be_a Hash
			expect(parsed).to eq(error: "The user's email was not included in this request")
		end
	end
end 