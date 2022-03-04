class Post < ApplicationRecord
  belongs_to :author, class_name: 'User'

  has_many :comments, dependent: :destroy
  has_many :likes, class_name: 'PostLike', counter_cache: :likes_count
  has_many :attachments, dependent: :destroy
  accepts_nested_attributes_for :attachments

  # posts can be an attachable in a posts model
  has_many :shares, as: :attachable, class_name: 'Attachment'
  alias_attribute :shares_count, :attaches_count

  scope :feed_for, ->(user) { where(author: User.and_friends(user)).limit(50) }

  validate :content_and_attachment

  paginates_per 5 

  def content_and_attachment
    validator = PostCustomValidator.new self
    validator.validate
  end

  def shared_post
    retriever = SharedPostRetriever.new self
    retriever.shared_post
  end

  def time
    TimePassed.format(updated_at)
  end
end



