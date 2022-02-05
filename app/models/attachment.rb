class Attachment < ApplicationRecord
  belongs_to :post
  belongs_to :attachable, polymorphic: true, counter_cache: :attaches_count
end
