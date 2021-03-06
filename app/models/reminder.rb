class Reminder < ActiveRecord::Base

	belongs_to :user
	after_create :schedule_reminder
	validate :reminders_within_limit, :on => :create
	validates :user_id, presence: true
	validates :hour, presence: true
	validates :duration, presence: true
	validates :day, presence: true
	validates :frequency, presence: true
	validates :complete_time, presence: true, :uniqueness => {message: "Failed. No Duplicates."}

	def reminders_within_limit
		if self.user.reminders.length > 5
			errors.add(:over_limit, "Sorry, you can only make 6 reminders.") 
		end
	end

	def send_message
		account_sid = ENV["account_sid"]
		auth_token = ENV["auth_token"]
		@client = Twilio::REST::Client.new(account_sid, auth_token)
		@message = @client.account.messages.create(
		  to: "+1" + self.user.phone_number,
		  from: "+12404910241",
		  body: "STREET CLEANING ALERT\n Reminder Name: #{self.reminder_name}\n Street cleaning will start in 12 hours!"
		)
		schedule_reminder
	end

	def schedule_reminder
		time_object = Reminder.create_runtime(self.hour, self.day, self.frequency)
		datetime_object = DateTime.parse(time_object.to_s)
		self.delay(run_at: datetime_object, reminder_id: self.id).send_message
	end

	def self.create_runtime(hour, day, frequency)
		run_time = nil
		month = ""
		case (DateTime.now + 1*(0.5)).month
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
		# wday = ""
		# case DateTime.now.wday
		# 	when 0
		# 		wday = 'sunday'
		# 	when 1
		# 		wday = 'monday'
		# 	when 2
		# 		wday = 'tuesday'
		# 	when 3
		# 		wday = 'wednesday'
		# 	when 4
		# 		wday = 'thursday'
		# 	when 5
		# 		wday = 'friday'
		# 	when 6
		# 		wday = 'saturday'
		# end
		one_week = (24*60*60*7)
		twelve_hours = (12*60*60)
		time_of_day = (hour*60*60)
		if frequency == 'weekly' && Time.now + twelve_hours <= Chronic.parse("next #{day}") - twelve_hours + time_of_day
			run_time = Chronic.parse("next #{day}") - twelve_hours + time_of_day
		elsif frequency == 'weekly' && Time.now + twelve_hours > Chronic.parse("next #{day}") - twelve_hours + time_of_day
			run_time = Chronic.parse("next #{day}") - twelve_hours + time_of_day + one_week
		elsif frequency == '1st and 3rd' || frequency == '2nd and 4th'
			if Time.now + twelve_hours <= Chronic.parse("1st #{day} this #{month}") - twelve_hours + time_of_day
				if frequency == '1st and 3rd'
					run_time = Chronic.parse("1st #{day} this #{month}") - twelve_hours + time_of_day
				else
					run_time = Chronic.parse("2nd #{day} this #{month}") - twelve_hours + time_of_day
				end
			elsif Time.now + twelve_hours <= Chronic.parse("2nd #{day} this #{month}") - twelve_hours + time_of_day
				if frequency == '1st and 3rd'
					run_time = Chronic.parse("3rd #{day} this #{month}") - twelve_hours + time_of_day
				else
					run_time = Chronic.parse("2nd #{day} this #{month}") - twelve_hours + time_of_day
				end
			elsif Time.now + twelve_hours <= Chronic.parse("3rd #{day} this #{month}") - twelve_hours + time_of_day
				if frequency == '1st and 3rd'
					run_time = Chronic.parse("3rd #{day} this #{month}") - twelve_hours + time_of_day
				else
					run_time = Chronic.parse("4th #{day} this #{month}") - twelve_hours + time_of_day
				end
			elsif Time.now + twelve_hours <= Chronic.parse("4th #{day} this #{month}") - twelve_hours + time_of_day
				if frequency == '2nd and 4th'
					run_time = Chronic.parse("4th #{day} this #{month}") - twelve_hours + time_of_day
				else
					run_time = Chronic.parse("1st #{day} next month") - twelve_hours + time_of_day
				end
			else
				if frequency == '1st and 3rd' && Time.now + twelve_hours > Chronic.parse("1st #{day} next month") - twelve_hours + time_of_day
					run_time = Chronic.parse("3rd #{day} next month") - twelve_hours + time_of_day
				elsif frequency == '2nd and 4th'
					run_time = Chronic.parse("2nd #{day} next month") - twelve_hours + time_of_day
				elsif frequency == '1st and 3rd'
					run_time = Chronic.parse("1st #{day} next month") - twelve_hours + time_of_day
				end
			end
		end
		run_time - (12*60*60)
	end
end

