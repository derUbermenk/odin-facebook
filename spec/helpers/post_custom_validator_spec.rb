require 'rails_helper'

RSpec.describe PostCustomValidator do

  let (:author) {
    create :user
  }

  let(:post) {
    create :post, author: author
  }

  let(:shareable_post) {
    create :post, author: author
  }

  subject{ described_class.new(post) }

  describe 'Validations' do
    context 'valid conditions' do
      it 'is expected to make post valid if it has not more than 500 characters' do
        post.content = Array.new(499, 'c').join # make post content 499 chars long

        expect(post).to be_valid
      end

      it 'is expected to make post valid if it has either a content or a 
        attachment with post attachable but not both' do

        # with content and no post attachment
        post.content = 'something'
        expect(post).to be_valid

        # without content but no post attachment
        post.content = nil
        post.attachments.new(attachable: shareable_post)
        expect(post).to be_valid
      end

      it 'is expected to make a post valid if it has only one attachment with attachable post' do
        post.attachments.new(attachable: shareable_post)
        expect(post).to be_valid
      end
    end

    context 'invalid conditions' do
      it 'is expected to make post invalid if it has more than 500 characters' do
        post.content = Array.new(502, 'c').join
        expect(post).to_not be_valid
      end

      it 'is expected to make post invalid if it has neither content or attachment' do
        post.content = nil

        expect(post).to_not be_valid
      end

      it 'is expected to make post invalid if it has more than one attachment and it one is of type post' do
        # create 1st post attachments
        post.attachments.create(attachable: shareable_post)

        # try adding a new one
        post.attachments.new(attachable: shareable_post)

        expect(post).to_not be_valid
      end
    end
  end
end
