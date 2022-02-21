class Attachment < ApplicationRecord
  belongs_to :post, counter_cache: :attachments_count
  belongs_to :attachable, polymorphic: true, counter_cache: :attaches_count, optional: true
end
