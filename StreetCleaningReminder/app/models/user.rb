require 'bcrypt'

class User < ActiveRecord::Base


	#has_many :saved_tests

	#validates :email, presence: true, uniqueness: true
	#validates :hash_password, presence: true

	include BCrypt

	def password
		@password ||= Password.new(hash_password)
	end

	def password=(new_password)
		@password = Password.create(new_password)
		self.hash_password = @password
	end

end
