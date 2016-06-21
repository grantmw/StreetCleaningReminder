class Reminder < ActiveRecord::Base
	belongs_to :user
	after_create :schedule_reminder

	# account_sid = APP_CONFIG['account_sid']
	# auth_token = APP_CONFIG['auth_token']
	# @client = Twilio::REST::Client.new(account_sid, auth_token)


	validates :user_id, presence: true
	validates :hour, presence: true
	validates :minute, presence: true
	validates :day, presence: true
	validates :frequency, presence: true

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
		schedule_reminder
	end

	def schedule_reminder
		# curr_year = Time.now.year
		# curr_month = Time.now.month
		# curr_day = Time.now.day
		# curr_week_day = Time.now.wday
		# sc_day = self.day.to_i
		# days_until = 0
		# if curr_week_day < sc_day
		# 	days_until = sc_day - curr_week_day
		# else
		# 	days_until = 7 + (sc_day - curr_week_day)
		# end
		# # if self.frequency == "weekly"

		# # end
		# p "poop"
		# p self.hour
		# p self.frequency
		p "it ran" * 10
		next_minute = Time.now.min + 1
		time = DateTime.new(2016,6,19,00, next_minute,30,'-7')
		self.delay(run_at: time).send_message
	end

	def reschedule
	end
end

