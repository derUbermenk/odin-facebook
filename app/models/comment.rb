class Comment < ApplicationRecord
  belongs_to :user
  belongs_to :post

  validates :content, presence: true, length: { in: 1..75 }
 
  def time
    current_year = Time.now.year
    days_since_post = ((Time.now - updated_at)/1.day).ceil
    hours_since_post = ((Time.now - updated_at)/1.hour).ceil
    mins_since_post = ((Time.now - updated_at)/1.minute).ceil

    if current_year > updated_at.year
      updated_at.strftime("%b %d, %Y")
    elsif days_since_post >= 7
      updated_at.strftime("%b %d")
    elsif hours_since_post > 6
      updated_at.strftime("%A")
    elsif hours_since_post > 1
      "#{hours_since_post} hr"
    else
      "#{mins_since_post} min"
    end
  end 
end
