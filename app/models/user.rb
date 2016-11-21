require 'bcrypt'

class User < ActiveRecord::Base
	has_many :reminders
	validates :user_name, presence: true, length: {within: 3..12, :message => "Username must be 3-12 characters in length."}
	validates 	:phone_number, 
				presence: true, 
				:uniqueness => {message: "Phone number already in use."},
				:numericality => {message: 'Must be a valid phone number.'},
				length: {within: 10..15, :message => "Phone number must be 10-15 numbers in length."}
	include BCrypt

	def password
		@password ||= Password.new(hash_password)
	end

	def password=(new_password)
		@password = Password.create(new_password)
		self.hash_password = @password
	end
end
