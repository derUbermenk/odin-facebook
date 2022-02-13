module UsersHelper
  module FriendRequest
    # sends a friend request
    def send_request(recipient)
      sent_friend_requests.create(
        recipient: recipient
      )
    end

    # accepts a friend request from the given sender
    def accept_request(sender)
      UserConnection.accept_connection(sender, self)
    end

    # reject request from the given sender
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
    # get the union of all accepted and added friendships
    def friendships
      accepted_friendships | added_friendships
    end

    # get a relation containing all users the are friends 
    #   with the calling user
    def friends
      accepted_friends.or added_friends
    end

    # get a relation containing all users mutual to other user
    #   and calling user
    def mutual_friends(other_user)
      friends.and other_user.friends
    end

    # unfriend the friend and the calling user
    def unfriend(friend)
      UserConnection.delete_connection(friend, self)
    end

    # returns all users that have no connections with user
    def self.no_connections(user)
      exclude_ids = user.friends.pluck(:id) | user.sent_friend_requests.pluck(:recipient_id) | user.received_friend_requests.pluck(:initiator_id)
      User.where.not(id: exclude_ids).order("RANDOM()").limit(20)
    end

    private

    # accepted refers to all connections where self is recipient
    # added refers to all connections where self is initiator

    def accepted_friends
      # get all friends of self for which user is the recipient in the friendship
      ids = UserConnection.where(recipient: self, status: :accepted).pluck(:initiator_id)
      User.where(id: ids)
    end

    def added_friends
      # get all friends of self for which user is the initiator in the friendship
      ids = UserConnection.where(initiator: self, status: :accepted).pluck(:recipient_id)
      User.where(id: ids)
    end

    # return a collection of arrays with the following format
    #   [ connection_id, friend_id, friend.username, accepted_at ]
    #   which represent all connection for which calling user is a recipient
    def accepted_friendships
      UserConnection.joins(:initiator)
                    .where(recipient_id: id, status: :accepted)
                    .order('accepted_at DESC')
                    .pluck('user_connections.id', :initiator_id, 'users.username', :accepted_at)
    end

    # same as accepted_friendships, but calling user is an initiator
    def added_friendships
      UserConnection.joins(:recipient)
                    .where(initiator_id: id, status: :accepted)
                    .order('accepted_at DESC')
                    .pluck('user_connections.id', :recipient_id, 'users.username', :accepted_at)
    end
  end

  module PostLiking
    def like(post)
      post_likes.create(post: post)
    end

    def unlike(post)
      # need to use destroy vs delete in order to for rails to call decrement counter
      post_likes.find_by(post: post).destroy
    end

    def liked?(post)
      post.in?(liked_posts)
    end
  end

  module PostSharing
    def share(post)
      new_post = posts.new
      new_post.attachments.build(attachable: post)
      new_post.save!
      new_post
    end
  end
end
