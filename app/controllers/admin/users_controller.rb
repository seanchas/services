class Admin::UsersController < ApplicationController
  
  helper "admin"
  
  layout "admin"
  
  def index
    @users = User.paginate(:joins => :user_infosell_requisites, :page => params[:page], :per_page => 20)
  end
  
end
