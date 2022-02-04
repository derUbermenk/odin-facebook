class Post < ApplicationRecord
  belongs_to :author, class_name: 'User'

  has_many :comments
  has_many :likes, class_name: 'PostLike', counter_cache: :likes_count

  # shares
  has_many :attachments, as: :attachable
  alias_attribute :attachments, :shares
  alias_attribute :attachments_count, :shares_count

  validates :content, presence: true,
                      length: {
                        in: 1..500,
                        tokenizer: ->(str) { str.split }
                      }
end
