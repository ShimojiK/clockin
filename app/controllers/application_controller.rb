class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  before_action :user?, :password_changed?
  helper_method :current_user

  private
  def current_user
    @current_user ||= User.find(session[:user_id]) if session[:user_id]
  end

  def user?
    unless current_user
      redirect_to signin_users_path
    end
  end

  def password_changed?
    unless current_user.password_changed
      redirect_to edit_users_path
    end
  end
end
