class UsersController < ApplicationController
  def index
    @friends = current_user.friends
    @sent_requests = current_user.sent_friend_requests
    @friend_suggestions = current_user.suggested_users
  end
end
