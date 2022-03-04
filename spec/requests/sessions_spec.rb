require 'rails_helper'

RSpec.describe "Sessions", type: :request do

  context 'when not logged in' do
    it 'redirects to new user session' do
      get root_path 
      expect(response).to redirect_to(new_user_session_path)
    end
  end

  context 'when logged in' do
    before :each do
      # sign in user
      @user = create :user
      post user_session_path, params: {
        user: {
          email: @user.email,
          password: @user.password,
        }
      }
    end

    it 'redirects to root' do
      get root_path
      expect(response).to render_template('posts/index')
      expect(response).to have_http_status(:success)

      assert_select '#notice', 'Signed in successfully.'
    end

    it 'provides a profile path' do
      get profile_path
      expect(response).to render_template('users/show')

      # renders users profile
      assert_select '#username', 'default'
      assert_select '#profile-edit', 'Edit Profile'
    end

    it 'should provide a sign out path' do
      get root_path

      assert_select 'a[href=?]', destroy_user_session_path 
    end

    it 'provides a logout path and logs user out' do
      delete destroy_user_session_path
      expect(response).to redirect_to(root_path)

      follow_redirect!

      expect(response).to redirect_to(new_user_session_path)
    end
  end
end
