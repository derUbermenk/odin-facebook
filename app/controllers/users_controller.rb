class UsersController < ApplicationController
  before_action :authenticate_user!

  def index
    @received_requests = current_user.received_friend_requests
    @suggestions = current_user.suggested_users
  end

  def show
    @user = User.find(params[:id])
    @user_friends_count = @user.friends.count
    @mutual_friends_count = @user.mutual_friends(current_user).count
    @posts = Post.where(author: @user)
    @connection = UserConnection.find_with_users(@user, current_user)
  end
end
