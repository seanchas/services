class OrdersController < ApplicationController
  
  before_filter :authenticate!
  before_filter :authenticated_requisite!
  
  def index
    @orders = Infosell::Order.all(authenticated_user.infosell_requisite)
  end
  
  def new
    service = Infosell::Service.find(params[:service_id])
    redirect_to service_path(service) and return if service.blocks.empty?
    @order = Infosell::Order.new(service, authenticated_user.infosell_requisite)
  end
  
  def create
    service = Infosell::Service.find(params[:service_id])
    @order = Infosell::Order.new(service, authenticated_user.infosell_requisite, params[:infosell_order])
    @order.validate and return if request.xhr?

    if @order.save
      redirect_to :orders
    else
      @order.validate if @order.errors.empty?
      render :new
    end
  end
  
  def edit
    @order = Infosell::Order.find(authenticated_user.infosell_requisite, params[:id])
  end
  
  def update
    @order = Infosell::Order.find(authenticated_user.infosell_requisite, params[:id])
    @order.attributes = params[:infosell_order]
    @order.validate and return if request.xhr?

    if @order.save
      redirect_to :orders
    else
      @order.validate
      render :edit
    end
  end
  
  def destroy_many
    Infosell::Order.destroy(authenticated_user.infosell_requisite, *params[:id])
    redirect_to :orders
  end
  
end
