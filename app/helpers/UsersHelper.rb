module UsersHelper
  module FriendRequest
    # sends a friend request
    def send_request(recipient)
      sent_friend_requests.create(
        recipient: recipient
      )
    end

    # accepts a friend request
    def accept_request(sender)
      UserConnection.accept_connection(sender, self)
    end

    def reject_request(sender)
      UserConnection.delete_connection(self, sender)
    end

    # returns the a proc for querying all the pending connections
    #   include the given role in the query
    # @param role [Symbol]
    # @return [Proc]
    def self.requests(role)
      lambda do
        where(status: :pending)
          .includes(role)
          .order(sent_at: :desc)
      end
    end
  end

  module Friends
    def friendships
      accepted_friendships | added_friendships
    end

    def friends
      accepted_friends.or added_friends
    end

    def mutual_friends(other_user)
      friends.and other_user.friends
    end

    def unfriend(user)
      UserConnection.delete_connection(user, self)
    end

    private

    # accepted refers to all connections where self is recipient
    # added refers to all connections where self is initiator

    def accepted_friends
      # get all friends of self for which user is the recipient in the friendship
      ids = UserConnection.where(recipient: self.id, status: :accepted).pluck(:initiator_id)
      User.where(id: ids)
    end

    def added_friends
      # get all friends of self for which user is the initiator in the friendship
      ids = UserConnection.where(initiator: self.id, status: :accepted).pluck(:recipient_id)
      User.where(id: ids)
    end

    def accepted_friendships
      UserConnection.joins(:initiator)
                    .where(recipient_id: id, status: :accepted)
                    .order('accepted_at DESC')
                    .pluck('user_connections.id', :initiator_id, 'users.username', :accepted_at)
    end

    def added_friendships
      UserConnection.joins(:recipient)
                    .where(initiator_id: id, status: :accepted)
                    .order('accepted_at DESC')
                    .pluck('user_connections.id', :recipient_id, 'users.username', :accepted_at)
    end
  end
end
