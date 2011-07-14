class ServicesController < ApplicationController

  before_filter :find_service, :except => :index
  
  # list all services
  def index
    @services = Infosell::Service.all((authenticated_user.try(:infosell_requisite) || '').to_param).select(&:accessible?)
  end
  
  # extended service description
  def show
    
  end
  
  # service offer
  def offer
    redirect_to service_path(@service) unless @service.offer?
  end

  # service price list
  def prices
    redirect_to service_path(@service) unless @service.prices?
  end

private

  def find_service
    @service = Infosell::Service.find(params[:id], (authenticated_user.try(:infosell_requisite) || '').to_param)
  end
  
end
