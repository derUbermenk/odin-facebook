# handles custom validations for a post model
class PostCustomValidator
  def initialize(post)
    @post = post
  end

  def validate
    either_with_content_or_attachment
    only_post_attachment_if_shared
    content_length
  end

  private

  def content_length
    error_message = 'Content must not have more than 500 characters'
    @post.content && 
      @post.content.length > 500 &&
      @post.errors.add(:content, error_message)
  end

  def either_with_content_or_attachment 
    error_message = 'must be present if no attachments included'
    @post.content.blank? &&
      @post.attachments.blank? &&
      @post.errors.add(:content, error_message)
  end

  def only_post_attachment_if_shared
    error_message = 'Post cannot contain more attachments when sharing other posts'
    @post.shared_post &&
      @post.attachments.many? &&
      @post.errors.add(:attachments, error_message)
  end
end