class OrdersController < ApplicationController
  
  def index
    @orders = Infosell::Order.all(authenticated_user.infosell_requisite)
  end
  
  def new
    @order = Infosell::Order.new(3, authenticated_user.infosell_requisite)
  end
  
  def create
    @order = Infosell::Order.new(3, authenticated_user.infosell_requisite, params[:infosell_order])
    if @order.save
      redirect_to :orders
    else
      render :new
    end
  end
  
  def edit
    @order = Infosell::Order.find(authenticated_user.infosell_requisite, params[:id])
  end
  
  def update
    @order = Infosell::Order.find(authenticated_user.infosell_requisite, params[:id])
    if @order.update_attributes(params[:infosell_order])
      redirect_to :orders
    else
      render :edit
    end
  end
  
end
