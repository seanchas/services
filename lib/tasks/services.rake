namespace :services do
  
  task :bootstrap => [:bootstrap_users, :bootstrap_relations] do
  end
  
  task :bootstrap_users => [:environment] do
    puts "=== Boostraping users"
    
    users_count = 0
    requisites_count = 0

    User.find_in_batches do |users_batch|

      users_count += users_batch.size
      
      counter = 0
      
      users_batch.each do |user|
        
        print "." if counter % 100 == 0
        counter += 1
        
        code = if Infosell::Requisite.check(user.nickname)
          user.nickname
        elsif Infosell::Requisite.check(user.email)
          user.email
        end
        
        user.user_infosell_requisites.create(:infosell_code => code) and requisites_count += 1 if code.present?

        STDOUT.flush 
      end
      puts " #{counter} users processed"
      
    end
    
    puts "=== Checked #{users_count} users"
    puts "=== Found #{requisites_count} requisites"
    
  end
  
  task :bootstrap_relations => [:environment] do
    puts "=== Bootstraping authorized url relations"
    
    class ElementaryResourceRelation < ActiveRecord::Base
      establish_connection "old_passport"
    end
    
    relations_count = 0
    
    ElementaryResourceRelation.find_in_batches do |relations_batch|
      relations_count += relations_batch.size
      
      relations_batch.each do |relation|
        r = AuthorizedUrlInfosellResource.new(relation.attributes)
        r.id = relation.id
        r.save!
      end
    end
    
    puts "#{relations_count} relations processed"
  end
  
end
