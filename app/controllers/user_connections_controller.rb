class UserConnectionsController < ApplicationController
  before_action :set_connection, except: %i[index create] 
  before_action :authenticate_user!

  def create
    recipient = User.find(params[:user_id])
    @request = current_user.sent_friend_requests.build recipient: recipient
    @request.save

    respond_to do |format|
      format.js{}
    end
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
      @connection = UserConnection.find(params[:id])
    end
end
