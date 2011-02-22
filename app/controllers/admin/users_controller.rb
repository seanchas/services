class Admin::UsersController < ApplicationController
  
  helper "admin"
  
  layout "admin"
  
  def index
    @users = User.paginate(:joins => :user_infosell_requisites, :include => :roles, :page => params[:page], :per_page => 20)
  end
  
  def edit
    @user = User.find(params[:id])
  end
  
  def update
    @user = User.find(params[:id])
    @user.update_attributes!(params[:user])
    redirect_to [:edit, :admin, @user]
  end
  
end
