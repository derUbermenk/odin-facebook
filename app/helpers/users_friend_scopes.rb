# custom scopes for querying a user models friends associations
module UsersFriendScopes
  def self.friends
    lambda do |user|
      unscope(:where, :where)
        .joins(
          <<-SQL
          INNER JOIN user_connections AS connections
            ON (connections.initiator_id = users.id OR connections.recipient_id = users.id)
            AND (connections.initiator_id = #{user.id} OR connections.recipient_id = #{user.id})
            AND (connections.status = 1)
          SQL
        )
        .where.not(id: user.id)
    end
  end
end