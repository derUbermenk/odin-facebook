class PostLike < ApplicationRecord
  belongs_to :liker, class_name: 'User'
  belongs_to :post, counter_cache: :likes_count
end
