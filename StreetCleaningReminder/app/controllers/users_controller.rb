# require 'rest_client'
# require 'json'

class UsersController < ApplicationController

  def create
    user = User.new(user_name: params['user_name'], password: params['password'], phone_number: params['phone_number'])
    if user.save
      render json: user.phone_number, status: :created
    else
      render nothing: true, status: 406
    end
  end

  def edit
  end

  def update
  end

  def destroy
  end
end
