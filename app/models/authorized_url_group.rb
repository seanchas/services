class AuthorizedUrlGroup < PassportModel
  
  has_many :authorized_urls, :foreign_key => :group_id, :order => :position
  
end
