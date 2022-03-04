class Comment < ApplicationRecord
  belongs_to :user
  belongs_to :post

  validates :content, presence: true, length: { in: 1..75 }
 
  def time
    TimePassed.format(updated_at)
  end 
end
