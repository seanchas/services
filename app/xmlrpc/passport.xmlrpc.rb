namespace :passport do

  task :openSession do
    Digest::SHA1.hexdigest(Time.new.to_s)
  end
  
  task :checkSession do |id|
    true
  end
  
  task :updateUserPermissions do |id, user_id, resources|
    begin
      user = User.find_by_infosell_requisite(user_id)
      user.update_access_flags(resources)
    rescue
      raise XMLRPC::FaultException.new(301, user_id)
    end
  end
  
  task :checkUid do |id, email|
    !!User.find_by_email(email)
  end

end
