class Admin::Base < ApplicationController
  skip_before_action :user?, :password_changed?
  before_action :admin?
  helper_method :current_admin
  layout 'layouts/application_admin'

  private
  def current_admin
    @current_admin ||= Admin.find(session[:admin_id]) if session[:admin_id]
  end

  def admin?
    unless current_admin
      redirect_to signin_admins_path
    end
  end
end
