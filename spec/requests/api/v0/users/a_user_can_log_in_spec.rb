require "rails_helper"

RSpec.describe "user login", type: :request do
	before(:each) do 
		User.delete_all
		User.create!(email: "mattyd@turing.edu", password: "pass123", password_confirmation: "pass123")
	end

	it "Api::V0::Users" do
		get "/api/v0/users", headers: { "Content-Type": "application/json", "Accept": "application/json" },
			params: { email: "mattyd@turing.edu", password: "pass123"}

		parsed = JSON.parse(response.body, symbolize_names: true)
		expect(response).to have_http_status(200)
    expect(parsed.keys).to eq([:data])

    expect(parsed[:data].keys).to match_array([:id, :type, :attributes])
    expect(parsed[:data][:id]).to be_an Integer
    expect(parsed[:data][:id]).to eq(User.last.id)
    expect(parsed[:data][:type]).to be_a String
    expect(parsed[:data][:type]).to eq("users")
    expect(parsed[:data][:attributes]).to be_a Hash
    expect(parsed[:data][:attributes].keys).to match_array([:email, :api_key])
    expect(parsed[:data][:attributes][:email]).to be_a String
    expect(parsed[:data][:attributes][:email]).to eq("mattyd@turing.edu")
		expect(parsed[:data][:attributes][:api_key]).to be_a String
		expect(parsed[:data][:attributes][:api_key]).to eq(User.last.api_key)
		expect(User.last.email).to eq("mattyd@turing.edu")
	end
end 