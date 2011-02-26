class AuthorizedUrl < PassportModel
  
  has_many :authorized_url_infosell_resources
  
  def self.find_by_infosell_resources(*ids)
    find(AuthorizedUrlInfosellResource.find_all_by_elementary_resource_id(ids).collect(&:authorized_url_id).flatten.compact.uniq)
  end

  def infosell_resources_codes
    @infosell_resources_codes ||= authorized_url_infosell_resources.collect(&:elementary_resource_id)
  end
  
end
