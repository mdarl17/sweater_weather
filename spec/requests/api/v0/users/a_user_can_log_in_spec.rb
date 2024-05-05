require "rails_helper"

RSpec.describe "user login", :vcr, type: :request do
	before(:each) do 
		User.delete_all
		@user = User.create!(email: "mattyd@turing.edu", password: "pass123", password_confirmation: "pass123", api_key: SecureRandom.hex(13))
		@user2 = User.create!(email: "juneau@dognapz.com", password: "woof123", password_confirmation: "woof123", api_key: SecureRandom.hex(13))
	end

	# user login
		# happy path
	describe "logging in" do 
		it "a user logs in if they give a valid (saved in DB) email and a valid password" do
			get "/api/v0/users", headers: { "Content-Type": "application/json", "Accept": "application/json" },
				params: { email: @user.email, password: @user.password }

			parsed = JSON.parse(response.body, symbolize_names: true)
			user = User.find(parsed[:data][:id])

			expect(response).to have_http_status(200)
			expect(parsed.keys).to eq([:data])
			expect(parsed[:data].keys).to match_array([:id, :type, :attributes])
			expect(parsed[:data][:id]).to be_an Integer
			expect(parsed[:data][:id]).to eq(user.id)
			expect(parsed[:data][:type]).to be_a String
			expect(parsed[:data][:type]).to eq("users")
			expect(parsed[:data][:attributes]).to be_a Hash
			expect(parsed[:data][:attributes].keys).to match_array([:email, :api_key])
			expect(parsed[:data][:attributes][:email]).to be_a String
			expect(parsed[:data][:attributes][:email]).to eq("mattyd@turing.edu")
			expect(parsed[:data][:attributes][:api_key]).to be_a String
			expect(parsed[:data][:attributes][:api_key]).to eq(user.api_key)
			expect(user.email).to eq("mattyd@turing.edu")
		end
	end

	# user login
		# sad path - no email provided
	describe "Blank email error" do 
		it "will return an error if no email is provided by user" do 
			get "/api/v0/users", headers: { "Content-Type": "application/json", "Accept": "application/json" },
				params: { email: " ", password: "pass123" }

			parsed = JSON.parse(response.body, symbolize_names: true)

			expect(parsed[:error]).to eq("User credential error: We could not find a user with the email/username combination used.")
		end
	end

	# user login
		# sad path - email not found
	describe "Wrong email error" do 
		it "will return an error if the provided email can't be matched against any saved in the system" do 
			get "/api/v0/users", headers: { "Content-Type": "application/json", "Accept": "application/json" },
				params: { email: "mdarl1717@gmail.com", password: "pass123" }

			parsed = JSON.parse(response.body, symbolize_names: true)

			expect(parsed[:error]).to eq( "User credential error: We could not find a user with the email/username combination used.")
		end
	end

	# user login
		# sad path - no password provided
		describe "No password error" do 
			it "will return an error if no password is provided" do 
				get "/api/v0/users", headers: { "Content-Type": "application/json", "Accept": "application/json" },
					params: { email: "mattyd@turing.edu", password: " " }
	
				parsed = JSON.parse(response.body, symbolize_names: true)
				
				expect(parsed[:error]).to eq( "Valid email and password are required")
				expect(parsed[:error]).to eq( "Valid email and password are required")
			end
		end 

	# user login
		# sad path - wrong password
	describe "Wrong password error" do 
		it "will return an error if the user's password can't be authenticated" do 
			get "/api/v0/users", headers: { "Content-Type": "application/json", "Accept": "application/json" },
				params: { email: "mattyd@turing.edu", password: "pass8675309" }

			parsed = JSON.parse(response.body, symbolize_names: true)
			
			expect(parsed[:error]).to eq( "Valid email and password are required")
		end
	end 
end 