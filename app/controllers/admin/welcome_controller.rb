class Admin::WelcomeController < ApplicationController

  before_filter :admin_required!

  layout "admin"
  helper "admin"

private

  def admin_required!
    redirect_to root_path unless authenticated_user.admin?
  end

end
