class OrdersController < ApplicationController
  
  def index
    @orders = Infosell::Order.all(authenticated_user.infosell_requisite)
  end
  
  def new
    @order = Infosell::Order.new(1, authenticated_user.infosell_requisite)
  end
  
  def create
    @order = Infosell::Order.new(1, authenticated_user.infosell_requisite, params[:infosell_order])
    @order.validate and return if request.xhr?

    if @order.save
      redirect_to :orders
    else
      @order.validate
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
  
end
