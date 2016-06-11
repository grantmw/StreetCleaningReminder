require 'bcrypt'

class User < ActiveRecord::Base

	has_many :reminders

	validates :first_name, presence: true
	validates :phone_number, presence: true, uniqueness: true
	validates :hash_password, presence: true

	include BCrypt

	def password
		@password ||= Password.new(hash_password)
	end

	def password=(new_password)
		@password = Password.create(new_password)
		self.hash_password = @password
	end

	#trigger a message at a certain time, using attributes of User object

end
