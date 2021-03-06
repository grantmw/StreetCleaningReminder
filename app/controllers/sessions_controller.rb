class SessionsController < ApplicationController

	def create
		if user = User.find_by(phone_number: params["phone_number"])
			if user.password == params[:password]
				obj = {
					user_name: user.user_name,
					user_phone_number: user.phone_number,
					reminders: user.reminders
				}
				render json: obj, status: :created
			else
				render nothing: true, status: 400
			end
		else
			render nothing: true, status: 404	
		end
	end
end
