class Post < ApplicationRecord
  belongs_to :user
  has_many :comments

  validates :content, presence: true,
                      length: {
                        in: 1..500,
                        tokenizer: ->(str) { str.split }
                      }
end
