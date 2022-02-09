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

  def time
    current_year = Time.now.year
    days_since_post = ((Time.now - updated_at)/1.day).ceil
    hours_since_post = (Time.now - updated_at.to_time).ceil

    if current_year > updated_at.year
      updated_at.strftime("%b %d, %Y")
    elsif days_since_post >= 7 
      updated_at.strftime("%b %d")
    elsif hours_since_post > 6
      updated_at.strftime("%A")
    else
      "#{hours_since_post} hr"
    end
  end
end
