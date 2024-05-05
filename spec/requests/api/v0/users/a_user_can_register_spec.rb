require "rails_helper"

RSpec.describe "New User Registration", :vcr, type: :request do 
	before(:each) do 
		User.delete_all

		@happy_user = {
			email: "mdarl17@gmail.com",
			password: "pass",
			password_confirmation: "pass"
		}
	end

	describe "New user registration" do 
		it "given valid credentials, it can register a new user and save them to the database" do
			expect(User.all.count).to eq(0)
			expect(User.all).to eq([])

			post "/api/v0/users", headers: { "Content-Type": "application/json", 
																			"Accept": "application/json" 
																			},
														params: { user: @happy_user }.to_json
			
			parsed = JSON.parse(response.body, symbolize_names: true)

			expect(User.count).to eq(1)
			expect(response).to have_http_status(201)
			expect(parsed.keys).to eq([:data])
			expect(parsed[:data].keys).to match_array([:id, :type, :attributes])
			expect(parsed[:data][:id]).to be_an Integer
			expect(parsed[:data][:id]).to eq(User.last.id)
			expect(parsed[:data][:type]).to be_a String
			expect(parsed[:data][:type]).to eq("users")
			expect(parsed[:data][:attributes]).to be_a Hash
			expect(parsed[:data][:attributes].keys).to match_array([:email, :api_key])
			expect(parsed[:data][:attributes][:email]).to be_a String
			expect(parsed[:data][:attributes][:email]).to eq("mdarl17@gmail.com")
			expect(parsed[:data][:attributes][:api_key]).to be_a String
			expect(parsed[:data][:attributes][:api_key]).to eq(User.last.api_key)
			expect(User.last.email).to eq("mdarl17@gmail.com")
		end

		it "When a new user is registered they are assigned an alpha-numeric API key" do 
			User.delete_all
			new_user = {
				email: "mdarlngton@turing.edu", 
				password: "password", 
				password_confirmation: "password"
			}

			expect(User.all).to eq([])
			expect(User.count).to eq(0)
			expect(new_user[:api_key]).to eq(nil)

			post "/api/v0/users", params: { user: new_user }
			
			expect(User.count).to eq(1)

			parsed = JSON.parse(response.body, symbolize_names: true)

			expect(new_user[:email]).to eq(User.last.email)
			expect(new_user[:email]).to eq(parsed[:data][:attributes][:email])
			expect(parsed[:data][:attributes][:email]).to eq("mdarlngton@turing.edu")
			expect(User.last.email).to eq("mdarlngton@turing.edu")
			expect(parsed[:data][:attributes][:api_key]).to be_a String
			expect(parsed[:data][:attributes][:api_key].length).to eq(26)
			expect(parsed[:data][:attributes][:api_key]).to eq(User.last.api_key)
			expect(User.last.password).to be(nil)
			expect(User.last.password_digest).to be_a String
		end
	end 
end