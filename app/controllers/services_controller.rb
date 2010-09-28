class ServicesController < ApplicationController
  
  # list all services
  def index
    @services = Infosell::Service.all.select(&:accessible?)
  end
  
end
