class UsersController < ApplicationController
  before_action :set_user, except: [:index]
  before_action :authenticate_user!

  def index
    @received_requests = current_user.received_friend_requests
    @suggestions = User.no_connections(current_user)
  end

  def show
  end

  private

  # set current user as @user if no params[:id] is nil
  # this occurs in the case that the route if from "/profile"
  def set_user
    @user = params[:id] ? User.find(params[:id]) : current_user

    # setup related
    unless @user = current_user
      @connection = UserConnection.search(current_user, @user)
    end
  end
end
