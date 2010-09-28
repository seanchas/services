class ServicesController < ApplicationController

  before_filter :find_service, :except => :index
  
  # list all services
  def index
    @services = Infosell::Service.all.select(&:accessible?)
  end
  
  # extended service description
  def show
  end
  
  # service offer
  def offer
  end

private

  def find_service
    @service = Infosell::Service.find(params[:id])
  end
  
end
