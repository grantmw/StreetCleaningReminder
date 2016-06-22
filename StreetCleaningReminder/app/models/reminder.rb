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
		p time
		self.delay(run_at: time).send_message
	end

	def create_runtime(hour, day, frequency)
		run_time = nil
		month = ""
		case DateTime.now.month
			when 1
				month = 'january'
			when 2
				month = 'february'
			when 3
				month = 'march'
			when 4
				month = 'april'
			when 5
				month = 'may'
			when 6
				month = 'june'
			when 7
				month = 'july'
			when 8
				month = 'august'
			when 9
				month = 'september'
			when 10
				month = 'october'
			when 11
				month = 'november'
			when 12
				month = 'december'
		end
		wday = ""
		case DateTime.now.wday
			when 0
				wday = 'sunday'
			when 1
				wday = 'monday'
			when 2
				wday = 'tuesday'
			when 3
				wday = 'wednesday'
			when 4
				wday = 'thursday'
			when 5
				wday = 'friday'
			when 6
				wday = 'saturday'
		end
		if frequency == 'weekly'
			run_time = Chronic.parse("next #{day}")
		elsif frequency == '1st and 3rd' || frequency == '2nd and 4th'
			#check intervals
			#before 1st wday of month
			p run_time
			p day
			p month
			if Time.now <= Chronic.parse("1st #{day} this #{month}") - (12*60*60) + (hour*60*60)# - (12*60*60)
				if frequency == '1st and 3rd'
					run_time = Chronic.parse("1st #{day} this #{month}") - (12*60*60) + (hour*60*60)
				else
					run_time = Chronic.parse("2nd #{day} this #{month}") - (12*60*60) + (hour*60*60)
				end
			elsif Time.now <= Chronic.parse("2nd #{day} this #{month}") - (12*60*60) + (hour*60*60)# - (12*60*60)
				if frequency == '1st and 3rd'
					run_time = Chronic.parse("3rd #{day} this #{month}") - (12*60*60) + (hour*60*60)
				else
					run_time = Chronic.parse("2nd #{day} this #{month}") - (12*60*60) + (hour*60*60)
				end
			#before 3rd wday of month
			elsif Time.now <= Chronic.parse("3rd #{day} this #{month}") - (12*60*60) + (hour*60*60)# - (12*60*60)
				if frequency == '1st and 3rd'
					run_time = Chronic.parse("3rd #{day} this #{month}") - (12*60*60) + (hour*60*60)
				else
					run_time = Chronic.parse("4th #{day} this #{month}") - (12*60*60) + (hour*60*60)
				end
			elsif Time.now <= Chronic.parse("4th #{day} this #{month}") - (12*60*60) + (hour*60*60)# - (12*60*60)
				if frequency == '2nd and 4th'
					run_time = Chronic.parse("4th #{day} this #{month}") - (12*60*60) + (hour*60*60)
				else
					run_time = Chronic.parse("1st #{day} next month") - (12*60*60) + (hour*60*60)
				end
			else
				if frequency == '2nd and 4th'
					run_time = Chronic.parse("2nd #{day} next month") - (12*60*60) + (hour*60*60)
				end
			end
		end

		run_time
	end

end

