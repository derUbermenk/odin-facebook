require 'rails_helper'

RSpec.shared_context 'with existing user, post and postlikes table' do
  def setup_users
    @user = create(:user)
    @posts_author = create(:user, email: 'post_author@email.com')
  end

  def setup_posts
    @post = create(:post, author: @posts_author)
    @liked_post = create(:post, author: @posts_author)
  end

  def setup_likes
    create(:post_like, liker: @user, post: @liked_post)
  end

  before :example do
    setup_users
    setup_posts
    setup_likes
  end
end