class UserInfosellRequisite < ActiveRecord::Base
  
  belongs_to :user
  
  before_create :activate_requisite, :if => :first_requisite?
  
  def activate_requisite
    self.is_current = true
  end
  
  def first_requisite?
    user.user_infosell_requisites.empty?
  end
  
end
