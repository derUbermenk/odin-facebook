class Post < ApplicationRecord
  belongs_to :author, class_name: 'User'

  has_many :comments
  has_many :likes, class_name: 'PostLike', counter_cache: :likes_count

  # shares i.e. attachments, referring to the act of attaching
  has_many :attachments, as: :attachable
  alias_attribute :attachments, :shares
  alias_attribute :attachments_count, :shares_count

  # attached_objects actual attachements
  has_many :attached_objects, foreign_key: 'post_id', class_name: 'Attachment'

  validates :content, presence: true,
                      length: {
                        in: 1..500,
                        tokenizer: ->(str) { str.split }
                      }
end
