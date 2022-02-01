class Post < ApplicationRecord
  belongs_to :user

  has_many :comments
  has_many :likes, class_name: 'PostLike'

  validates :content, presence: true,
                      length: {
                        in: 1..500,
                        tokenizer: ->(str) { str.split }
                      }
end
