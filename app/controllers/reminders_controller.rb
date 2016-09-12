class RemindersController < ApplicationController
	
	def index
		if session[:id] = User.find_by(phone_number: params["user_phone_number"]).id
			user = User.find(session[:id])
			obj = {
					reminders: user.reminders
				}
			render json: obj, status: :created
		else
			render nothing: true, status: 404	
		end
	end

	def create
		user = User.find_by(phone_number: params["phone_number"])
		default_name = params[:reminder_name]
		if params[:reminder_name].length == 0
			default_name = "[No Name]"
		end
		reminder = Reminder.new(user_id: user.id, hour: params[:hourAndDuration][0..1].to_i, duration: params[:hourAndDuration][-2..-1].to_i, day: params[:day], frequency: params[:frequency], reminder_name: default_name, complete_time: params[:hourAndDuration][0..1] + params[:hourAndDuration][-2..-1] + params[:day] + params[:frequency] + user.id.to_s)
		if reminder.save
			obj = {
				reminders: user.reminders
			}
			render json: obj, status: :created
		else
			render json: reminder.errors.full_messages, status: 404
		end
	end

	def destroy
		if reminder = Reminder.find(params[:id])
			reminder.delete
			Delayed::Job.find_by(reminder_id: reminder.id).delete
		else
			render nothing: true, status: 404	
		end
	end
end
