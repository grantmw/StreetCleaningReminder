# require 'rest_client'
# require 'json'

class UsersController < ApplicationController
  def index
  end

  def new
  end

  def create
    user = User.new(first_name: params['email'], password: params['password'], phone_number: params['phone_number'])
    if user.save
      render json: user, status: :created
    else
      render nothing: true, status: 406
    end
  end

  def show
  end

  def edit
  end

  def update
  end

  def destroy
  end
end
