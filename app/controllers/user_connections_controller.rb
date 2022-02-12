class UserConnectionsController < ApplicationController
  before action :set_post, except: %i[create]
  before_action :authenticate_user!

  def create
    recipient = User.find(params[:user_id])
    @request = current_user.sent_friend_requests.build recipient: recipient
    @request.save
  end

  def update
    @connection.status = :accepted
    @connection.save
  end

  def destroy
    @connection.destroy
  end

  private

  def set_connection
    @connection = post.find(params[:id])
  end
end
