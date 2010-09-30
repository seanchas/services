class RequisitesController < ApplicationController
  
  def new
    @requisite = Infosell::Requisite.new(1)
  end
  
  def create
    @requisite      = Infosell::Requisite.new(1, params[:infosell_requisite])
    @requisite.code = "#{authenticated_user.email}:#{Time.now.to_s(:number)}"

    if @requisite.save
      authenticated_user.user_infosell_requisites.create(:infosell_code => @requisite.code)
      redirect_to :requisites
    else
      render :new
    end
  end
  
end
