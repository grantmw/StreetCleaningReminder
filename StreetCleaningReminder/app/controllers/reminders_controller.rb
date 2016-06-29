class RemindersController < ApplicationController
	#sessions don't seem to work, or matter, delete
	def index
		p "this is the reminders index"*10
		p session[:id]
		p params
		p params["user_phone_number"]
		p "*"*100
		# p "hello"
		# reminders = Reminder.where(user_id: session[:id])
		# render json: reminders
		if session[:id] = User.find_by(phone_number: params["user_phone_number"]).id
			p 'Printing from Reminders Index: the user is found, signed in and has refreshed reminders in the view'
			user = User.find(session[:id])
			obj = {
					# user_phone_number: user.phone_number,
					reminders: user.reminders
				}
			render json: obj, status: :created
		else
			render nothing: true, status: 404	
		end
	end

	def create
		p "8" * 10
		p params
		p params["phone_number"]
		p "8" * 10

		# reminder = Reminder.create()
		# reminder.send_message
		# p Time.now
		# time = DateTime.new(2016,6,8,16,50,30,'-7')
		# p time
		# reminder.delay(run_at: time).send_message
		if session[:id] = User.find_by(phone_number: params["phone_number"]).id
			p 'the user is found, signed in and is able to make reminder'
			Reminder.create(user_id: session[:id], hour: params[:hourAndDuration][0..1].to_i, duration: params[:hourAndDuration][-2..-1].to_i, day: params[:day], frequency: params[:frequency])
			user = User.find(session[:id])
			obj = {
					# user_phone_number: user.phone_number,
					reminders: user.reminders
				}
			render json: obj, status: :created
		else
			render nothing: true, status: 404	
		end
	end

	def destroy
		p "hit the destroy route, params to follow"
		p params

		#use destroy (with callback functionality) in model - refactor
		if reminder = Reminder.find(params[:id])
			reminder.delete
			Delayed::Job.find_by(reminder_id: reminder.id).delete
		else
			render nothing: true, status: 404	
		end

	end
end
