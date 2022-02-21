class UsersController < ApplicationController
  before_action :set_user
  before_action :authenticate_user!

  def index
    @received_requests = current_user.received_friend_requests
    @suggestions = User.no_connections(current_user)
  end

  def show
    @user_friends_count = @user.friends.count
    @mutual_friends_count = @user.mutual_friends(current_user).count
    @posts = Post.where(author: @user).order(updated_at: :desc).limit(20)
    @connection = UserConnection.find_with_users(@user, current_user)
  end

  private

  # set current user as @user if no params[:id] is nil
  # this occurs in the case that the route if from "/profile"
  def set_user
    @user = params[:id] ? User.find(params[:id]) : current_user
  end
end
