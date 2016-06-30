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
		p "*" * 80
		p params
		p "*" * 80

		# reminder = Reminder.create()
		# reminder.send_message
		# p Time.now
		# time = DateTime.new(2016,6,8,16,50,30,'-7')
		# p time
		# reminder.delay(run_at: time).send_message
		user = User.find_by(phone_number: params["phone_number"])
		reminder = Reminder.new(user_id: user.id, hour: params[:hourAndDuration][0..1].to_i, duration: params[:hourAndDuration][-2..-1].to_i, day: params[:day], frequency: params[:frequency], reminder_name: params[:reminder_name], complete_time: params[:hourAndDuration][0..1] + params[:hourAndDuration][-2..-1] + params[:day] + params[:frequency])
		if reminder.save
			p "In create route, successfully saved reminder"
			obj = {
				reminders: user.reminders
			}
			render json: obj, status: :created
		else
			p "In create route, failed to save reminder"
			# render nothing: true, status: 404	
			render json: reminder.errors.full_messages, status: 404
		end

		# end
		# 	user = User.find(session[:id])
		# 	obj = {
		# 			reminders: user.reminders
		# 		}
		# 	render json: obj, status: :created
		# else
		# 	p reminder.errors
		# 	render nothing: true, status: 404	
		# end
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
