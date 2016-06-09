class RemindersController < ApplicationController

	def create
		p params
		reminder = Reminder.create()
		p Time.now
		time = DateTime.new(2016,6,8,16,50,30,'-7')
		p time
		reminder.delay(run_at: time).send_message
	end
end
