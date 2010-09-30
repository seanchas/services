class User < PassportModel
  
  passport
  
  has_many :user_infosell_requisites
  
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
  
end
