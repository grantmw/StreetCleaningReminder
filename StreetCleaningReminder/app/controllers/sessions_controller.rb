class SessionsController < ApplicationController

	def create
		p "8*100"
		p params
		p "8*100"
		if user = User.find_by(phone_number: params["phone_number"])
			p 'hello'
			if user.password == params[:password]
				session[:id] = user.id
				obj = {
					user: user,
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
