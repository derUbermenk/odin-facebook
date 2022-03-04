# handles scopes for users connection scopes
#   this module was written to encapsulate complicated scopes
#   for a user connection associations
module UsersConnectionScopes

  # returns a proc to act as a scope for a connections asscociation
  #   to return connections regardless of scope
  # @return [Proc]
  def self.connections
    # associations work by doing a where on the foreing key of the associated 
    #   belongs to model. This then returns all the models that pass that where
    #   conditinal.
    #
    # for example, say a User model has many comments
    #   a "has_many :comments" will do something like
    #
    #     Comment.where(user_id: user.id)
    # 
    #   think of it as having a hidden scope with
    #   ->(user) { where user_id: user.id }
    #
    #   and if for some chance we decided to add a scope
    #   like 
    #
    #     "has_many :comments, -> { where(content: :many )}"
    #
    #  then calling user.comments will do something like
    #
    #     Comment.where(user_id: user.id).where( content: :many )
    #
    # In the code below we unscope the first where conditional
    #   that leaves us the duty to do the supposedly first where ourselves
    #   thus the need to add a user argument to the scope lambda ourselves
    lambda do |user|
      unscope(:where)
        .where('initiator_id = ? OR recipient_id = ?', user.id, user.id)
    end
  end

  def self.accepted_connections
    connections_with_status(:accepted)
  end

  def self.pending_connections
    connections_with_status(:pending)
  end

  # returns a proc to act as a scope for a connections asscociation
  #   based on status
  # @params status [Symbol]
  # @return [Proc]
  def self.connections_with_status(status)
    lambda do |user|
      unscope(:where)
        .where('initiator_id = ? OR recipient_id = ?', user.id, user.id)
        .where(status: status)
    end
  end
end
