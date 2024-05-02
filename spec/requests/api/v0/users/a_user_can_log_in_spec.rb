require "rails_helper"

RSpec.describe "user login", :vcr, type: :request do
	before(:each) do 
		User.delete_all
		@key = SecureRandom.hex(12)
		@user = User.create!(email: "mattyd@turing.edu", password: "pass123", password_confirmation: "pass123", api_key: @key)
	end

	# user login
		# happy path
		describe "logging in" do 
			it "a user logs in if they give a valid (saved in DB) email and a valid password" do
			get "/api/v0/users", headers: { "Content-Type": "application/json", "Accept": "application/json" },
				params: { email: "mattyd@turing.edu", password: "pass123" }

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

	# user login
		# sad path - no email provided
	describe "Blank email error" do 
		it "if email is blank, an error is returned and user is not saved" do 
			get "/api/v0/users", headers: { "Content-Type": "application/json", "Accept": "application/json" },
				params: { email: " ", password: "pass123" }
			expect("User credential error: We could not find a user with the email/username combination used.")
		end
	end

	describe "Wrong email error" do 
		it "if email is not in the system, a descriptive error is given to user" do 
			get "/api/v0/users", headers: { "Content-Type": "application/json", "Accept": "application/json" },
				params: { email: "mdarl1717@gmail.com", password: "pass123" }
			expect("Valid email and password are required")
		end
	end 
end 