class Post < ApplicationRecord
  belongs_to :author, class_name: 'User'

  has_many :comments
  has_many :likes, class_name: 'PostLike', counter_cache: :likes_count

  # attaches refers to all Attachment records where these particular attachable was attached
  has_many :shares, as: :attachable
  alias_attribute :shares_count, :attaches_count

  has_many :attachments, dependent: :destroy

  validate :content_or_attachment
  validates :content, length: { maximum: 500 }

  # validates :attachments, presence: true, unless: :content

  def content_or_attachment
    error_message = 'must be present if no attachments included'
    content.blank? && attachments.blank? && errors.add(:content, error_message)
  end
end
