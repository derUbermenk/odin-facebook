class UserConnectionsController < ApplicationController
  before_action :set_connection, except: %i[index create]
  before_action :authenticate_user!

  
  # render inline: "location.reload();" reloads the page
  #   as a response to the request
  def create
    recipient = User.find(params[:user_id])
    @request = current_user.sent_friend_requests.build recipient: recipient
    @request.save

    respond_to do |format|
      format.js {render inline: "location.reload();" }
    end
  end

  def update
    @connection.status = :accepted
    @connection.save

    respond_to do |format|
      format.js {render inline: "location.reload();" }
    end
  end

  def destroy
    @connection.destroy

    respond_to do |format|
      format.js {render inline: "location.reload();" }
    end
  end

  private
    def set_connection
      @connection = UserConnection.find(params[:id])
    end
end
