class ActiveRecord::Base

  def self.table_name_prefix
    "#{connection.current_database}."
  end
  
end