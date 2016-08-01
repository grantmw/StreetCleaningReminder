class UsersController < ApplicationController

  def create
    user = User.new(user_name: params['user_name'], password: params['password'], phone_number: params['phone_number'])
    if user.save
      render json: user.phone_number, status: :created
    else
      p user.errors
      render json: user.errors.full_messages, status: 406
    end
  end

end
