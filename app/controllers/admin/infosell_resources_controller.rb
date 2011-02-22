class Admin::InfosellResourcesController < Admin::WelcomeController

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
    relations = AuthorizedUrlInfosellResource.find_all_by_elementary_resource_id(@infosell_resource.code)
    @infosell_resource.update_attributes!(params[:infosell_resource])
    
    AuthorizedUrlInfosellResource.transaction do
      relations.each do |relation|
        relation.update_attribute :elementary_resource_id, @infosell_resource.code
      end
    end
    
  rescue Infosell::Resource::Invalid
    render :edit
  end
  
  def destroy
    @infosell_resource = Infosell::Resource.find(params[:id])
    @infosell_resource.destroy
  end
  
end
