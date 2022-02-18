class Post < ApplicationRecord
  belongs_to :author, class_name: 'User'

  has_many :comments, dependent: :destroy
  has_many :likes, class_name: 'PostLike', counter_cache: :likes_count

  # attaches refers to all Attachment records where these particular attachable was attached
  has_many :shares, as: :attachable, class_name: 'Attachment'
  alias_attribute :shares_count, :attaches_count

  has_many :attachments, dependent: :destroy
  accepts_nested_attributes_for :attachments

  validate :single_attachment_shares
  validate :content_or_attachment
  validates :content, length: { maximum: 500 }

  # validates :attachments, presence: true, unless: :content

  def content_or_attachment
    error_message = 'must be present if no attachments included'
    content.blank? && attachments.blank? && errors.add(:content, error_message)
  end

  # posts are invalid when there are more than one attachments and one is a post 
  def single_attachment_shares 
    error_message = 'Post cannot contain more attachments when sharing other posts'
    shared_post && attachments.many? && errors.add(:attachments, error_message)
  end

  def shared_post
    # &.method allows us to anticipate instances where the return of the
    attachments.first&.attachable
  end

  def time
    current_year = Time.now.year
    days_since_post = ((Time.now - updated_at)/1.day).ceil
    hours_since_post = ((Time.now - updated_at)/1.hour).ceil
    mins_since_post = ((Time.now - updated_at)/1.minute).ceil

    if current_year > updated_at.year
      updated_at.strftime("%b %d, %Y")
    elsif days_since_post >= 7
      updated_at.strftime("%b %d")
    elsif hours_since_post > 6
      updated_at.strftime("%A")
    elsif hours_since_post > 1
      "#{hours_since_post} hr"
    else
      "#{mins_since_post} min"
    end
  end 

  # returns the all the posts for the given user 
  def self.feed(user)
    user_and_friends = user.friends.pluck(:id) << user.id

    Post.where(author_id: user_and_friends).order('created_at DESC').limit(50)
  end
end
