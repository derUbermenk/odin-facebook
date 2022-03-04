# handles retrieving a given posts shared 
#   post if any, while taking to account
#   that the shared post may have been 
#   deleted
class SharedPostRetriever
  attr_reader :post

  def initialize(post)
    @post = post
  end

  def shared_post 
    attachment_with_post = @post.attachments.where(attachable_type: 'Post').take

    # if there is no attachment for which attachable type is post 
    #   then it is correct to assume that there is no shared post
    return nil unless attachment_with_post 

    # else look for attachable attachable
    # may not exist however in cases where
    #   where the attachable has
    attachment_with_post.attachable || deleted_post
  end

  # returns a deleted post model this is used
  #   a substitute where a post has another
  #   post attachment (share)
  def deleted_post
    Post.new(
      content: 'This post is no longer available'
    )
  end
end
