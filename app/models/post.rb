class Post < ApplicationRecord
  belongs_to :author, class_name: 'User'

  has_many :comments
  has_many :likes, class_name: 'PostLike', counter_cache: :likes_count

  # attaches refers to all Attachment records where these particular attachable was attached
  has_many :shares, as: :attachable
  alias_attribute :shares_count, :attaches_count

  has_many :attachments

  validates :content, presence: true,
                      length: {
                        in: 1..500,
                        tokenizer: ->(str) { str.split }
                      }
end
