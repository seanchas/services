class User < PassportModel
  
  passport
  
  has_many :user_infosell_requisites
  
  has_many :access_flags, :class_name => AuthorizedUrlAccessFlag.to_s
  
  def self.find_by_infosell_requisite(requisite)
    UserInfosellRequisite.find_by_infosell_code(requisite).try(:user) or raise ActiveRecord::RecordNotFound
  end
  
  def current_user_infosell_requisite
    @current_infosell_requisite ||= user_infosell_requisites.detect(&:is_current)
  end
  
  def infosell_requisites
    @infosell_requisites ||= user_infosell_requisites.empty? ? [] : Infosell::Requisite.find(user_infosell_requisites.collect(&:infosell_code))
  end
  
  def infosell_requisite
    infosell_requisites.detect { |requisite| requisite.code == current_user_infosell_requisite.infosell_code } || infosell_requisites.first unless infosell_requisites.empty?
  end
  

  def full_name
    @full_name ||= [last_name, first_name, middle_name].compact.join(" ")
  end
  
  def screen_name
    @screen_name ||= full_name.blank? ? nickname : full_name
  end
  

  def update_access_flags(resources_ids = [], name = "infosell")
    resources       = Infosell::Resource.all.select { |r| resources_ids.include? r.code }
    authorized_urls = AuthorizedUrl.find_by_infosell_resources(*resources.collect(&:code))

    access_flags_to_keep, access_flags_to_destroy = access_flags.partition { |f| f.author == 'admin' }

    AuthorizedUrlAccessFlag.transaction do
      access_flags_to_destroy.each(&:destroy)
      (authorized_urls.collect(&:id) - access_flags_to_keep.collect(&:authorized_url_id)).each do |id|
        access_flags.create :authorized_url_id => id, :author => name
      end
    end
    
    true
  end
  
end
