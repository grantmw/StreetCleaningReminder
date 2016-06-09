class Reminder < ActiveRecord::Base
	belongs_to :user

	# account_sid = APP_CONFIG['account_sid']
	# auth_token = APP_CONFIG['auth_token']
	# @client = Twilio::REST::Client.new(account_sid, auth_token)


	def send_message
		# Rails.logger.debug(@client)
		p "ran send_message"

		account_sid = APP_CONFIG['account_sid']
		auth_token = APP_CONFIG['auth_token']
		@client = Twilio::REST::Client.new(account_sid, auth_token)

		@message = @client.account.messages.create(
		  to: "+13015806553",
		  from: "+12404910241",
		  body: "Please work Please work Please work"
		)
	end
end
