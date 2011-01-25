class Admin::InfosellResourcesRelationsController < ApplicationController

  layout "admin"

  helper "admin"
  
  def index
    @infosell_resources = Infosell::Resource.all
  end
  
  def show
    @infosell_resource = Infosell::Resource.find(params[:id])
    @authorized_url_groups = AuthorizedUrlGroup.all(:order => :position, :include => { :authorized_urls => :authorized_url_infosell_resources })
  end
  
  def update
    @infosell_resource = Infosell::Resource.find(params[:id])
    @authorized_url = AuthorizedUrl.find(params[:authorized_url_id])
    case params[:state]
      when "create"
        @authorized_url.authorized_url_infosell_resources.create(:elementary_resource_id => @infosell_resource.code)
      when "destroy"
        @authorized_url.authorized_url_infosell_resources.find_by_elementary_resource_id(@infosell_resource.code).try(:destroy)
    end
    render :nothing => true
  end
  
end
