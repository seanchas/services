class OrdersController < ApplicationController
  
  def index
    @orders = Infosell::Order.all(authenticated_user.infosell_requisite)
  end
  
  def new
    @order = Infosell::Order.new(2, authenticated_user.infosell_requisite)
  end
  
  def create
    @order = Infosell::Order.new(2, authenticated_user.infosell_requisite, params[:infosell_order])
    @order.save
  end
  
  def edit
    @order = Infosell::Order.find(authenticated_user.infosell_requisite, params[:id])
  end
  
end
