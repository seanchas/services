class User < PassportModel
  
  passport
  
  has_many :user_infosell_requisites
  
  def infosell_requisites
    []
  end
  
  def full_name
    @full_name ||= [last_name, first_name, middle_name].compact.join(" ")
  end
  
  def screen_name
    @screen_name ||= full_name.blank? ? nickname : full_name
  end
  
end
