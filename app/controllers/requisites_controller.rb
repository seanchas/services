class RequisitesController < ApplicationController

  before_filter :authenticate!

  def show
    if @requisite = authenticated_user.infosell_requisite
      render :edit
    else
      @requisite_type = Infosell::RequisiteType.find(params[:requisite_type])
      @requisite      = Infosell::Requisite.new(@requisite_type) if @requisite_type
      render :new
    end
  end
  
  def create
    @requisite_type = Infosell::RequisiteType.find(params[:requisite_type])
    redirect_to :requisite and return unless @requisite_type

    @requisite      = Infosell::Requisite.new(@requisite_type, params[:infosell_requisite])
    @requisite.code = "#{authenticated_user.email}:#{Time.now.to_s(:number)}"

    if @requisite.save
      authenticated_user.user_infosell_requisites.create(:infosell_code => @requisite.code)
      redirect_to :requisite
    else
      render :new
    end
  end
  
  def update
    @requisite = authenticated_user.infosell_requisite
    if @requisite.update_attributes(params[:infosell_requisite])
      redirect_to :requisite
    else
      render :edit
    end
  end
  
end
