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
		p "8" * 10
		p params
		p "8" * 10

		Reminder.create(user_id: 1, hour: params[:time][0..1].to_i, minute: params[:time][-2..-1].to_i, day: params[:day], frequency: params[:frequency])
		# reminder = Reminder.create()
		# reminder.send_message
		# p Time.now
		# time = DateTime.new(2016,6,8,16,50,30,'-7')
		# p time
		# reminder.delay(run_at: time).send_message
	end
end
