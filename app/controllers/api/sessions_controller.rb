class Api::SessionsController < ApplicationController
  def new
    render :new
  end

  def create
    @user = User.find_by_credentials(
      params[:user][:username],
      params[:user][:password]
    )
    if @user
      log_in!(@user)
      render :template => '/api/users/show'
    else
      flash.now[:errors] = ['Invalid username/password']
      render :new
    end
  end

  def destroy
    log_out!
    render json: {}
  end
end
