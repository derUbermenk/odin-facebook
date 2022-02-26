require 'rails_helper'
RSpec.describe SharedPostRetriever do
  
  let(:author) {
    create :user 
  }

  let(:post) {
    create :post, author: author 
  }

  let(:shareable_post) {
    create :post, author: author 
  }

  subject{ described_class.new(post) }

  describe 'Retriever' do
    it 'expected to return the shared post if there is one' do
      post.attachments.create(attachable: shareable_post)
      expect(subject.shared_post).to eq(shareable_post)
    end

    it 'expected to return an instance of a post model with
      content: "This post is no longer available" when the
      shared post has been deleted' do

      # create an attachment then destroy the attached post
      #   but keep the attachment
      post.attachments.create(attachable: shareable_post)
      post.attachments.first.attachable.destroy

      expect(subject.shared_post.content).to eq 'This post is no longer available'
      expect(subject.shared_post.author).to be nil
    end
  end
end

