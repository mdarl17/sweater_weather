class User < ApplicationRecord 
	validates :email, presence: true, uniqueness: true, format: { with: URI::MailTo::EMAIL_REGEXP }
	validates :password, presence: true, confirmation: true
	validates :api_key, uniqueness: true

	has_secure_password

	def generate_api_key
		self.api_key = SecureRandom.hex(13)
	end
end