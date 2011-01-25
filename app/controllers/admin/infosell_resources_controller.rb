class Admin::InfosellResourcesController < ApplicationController

  layout "admin"
  
  helper "admin"
  
  def index
    @infosell_resources = Infosell::Resource.all
  end
  
  def show
    @infosell_resource = Infosell::Resource.find(params[:id])
  end
  
  def new
    @infosell_resource = Infosell::Resource.new :code => "", :name => "", :kind => "", :description => ""
  end
  
  def create
    @infosell_resource = Infosell::Resource.new(params[:infosell_resource])
    @infosell_resource.save!
  rescue Infosell::Resource::Invalid
    render :new
  end
  
  def edit
    @infosell_resource = Infosell::Resource.find(params[:id])
  end
  
  def update
    @infosell_resource = Infosell::Resource.find(params[:id])
    @infosell_resource.update_attributes!(params[:infosell_resource])
  rescue Infosell::Resource::Invalid
    render :edit
  end
  
  def destroy
    @infosell_resource = Infosell::Resource.find(params[:id])
    @infosell_resource.destroy
  end
  
end
