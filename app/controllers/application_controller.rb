class ApplicationController < ActionController::Base
  before_action :configure_permitted_parameters, if: :devise_controller?

  def like_text
    @liked ? 'Unlike' : 'Like'
  end

  def likes_count_text
    operation = @liked ? '+' : '-'
    @likes_count.send(operation, 1)
  end

  helper_method :like_text, :likes_count_text

  protected
  def authenticate_user!
    if user_signed_in?
      super
    else
      redirect_to new_user_session_path
    end
  end

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:username])
  end
end
