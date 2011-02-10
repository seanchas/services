namespace :passport do

  task :open_session do |id|
    id
  end
  
  task :check_session do |id|
    true
  end
  
  task :update_user_permissions do |id, user_id, resources|
    begin
      user = User.find_by_infosell_requisite(user_id)
      user.update_access_flags(resources)
    rescue
      raise XMLRPC::FaultException.new(301, user_id)
    end
  end

end
