class UsersController < ApplicationController
  def index
    @friends = current_user.friends
    @sent_requests = current_user.sent_friend_requests
    @friend_suggestions = current_user.suggested_users
  end

  def show
    @user = User.find(params[:id])
    @user_friends_count = @user.friends.count
    @mutual_friends_count = @user.mutual_friends(current_user).count
    @posts = Post.where(author: @user)
    @connection = UserConnection.find_with_users(@user, current_user)
  end
end
