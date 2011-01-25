class AuthorizedUrl < PassportModel
  
  has_many :authorized_url_infosell_resources

  def infosell_resources_codes
    @infosell_resources_codes ||= authorized_url_infosell_resources.collect(&:elementary_resource_id)
  end
  
end
