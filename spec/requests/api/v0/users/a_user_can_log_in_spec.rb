require "rails_helper"

RSpec.describe "user login", type: :request do
	it "Api::V0::Users" do
		post "/api/v0/users", headers: { "Content-Type": "application/json", "Accept": "application/json" },
			params: { email: "mattyd@turing.edu", password: "pass123"}.to_json
		require 'pry'; binding.pry
	end
end 