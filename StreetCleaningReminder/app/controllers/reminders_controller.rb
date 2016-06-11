class RemindersController < ApplicationController

	def index
		# p "*"*100
		# p session[:id]
		# p "*"*100
		# p "hello"
		# reminders = Reminder.where(user_id: session[:id])
		# render json: reminders
	end

	def create
		p params
		# reminder = Reminder.create()
		# p Time.now
		# time = DateTime.new(2016,6,8,16,50,30,'-7')
		# p time
		# reminder.delay(run_at: time).send_message
	end
end
