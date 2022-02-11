class UserConnectionsController < ApplicationController
  before_action :authenticate_user!

  def create
    recipient = User.find(params[:id])
    @request = current_user.sent_friend_requests.new(
      recipient: recipient,
      status: :pending
    )

    respond_to do |format|
      if @request.save
        format.html {}
        format.js {}
      else
        format.html {}
        format.js {}
      end
    end
  end
end
