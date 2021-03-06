set :application, "services"
set :repository,  "http://github.com/seanchas/services.git"
set :user,        :ror
set :runner,      :ror
set :use_sudo,    false

set :deploy_to,   "/export/depo/ror/linux/appservers/#{application}"
set :deploy_via,  :copy

set :scm, :git

set :bundle_cmd,  "/opt/gnu/ror/bin/bundle"
require 'bundler/capistrano'

namespace :deploy do
  task :start do ; end
  task :stop do ; end
  task :restart, :roles => :app, :except => { :no_release => true } do
    run "#{try_sudo} touch #{File.join(current_path,'tmp','restart.txt')}"
  end
end

configuration = [
  'config/database.yml',
  'config/initializers/passport.rb',
  'config/initializers/infosell.rb',
  'config/environments/production.rb',
  'config/locales/en.yml',
  'config/locales/ru.yml'
]

namespace :deploy do

  task :update_configuration, :roles => :app do
    configuration.each do |entry|
      run <<-CMD
        if [ -f #{release_path}/#{entry} ]; then rm -f #{release_path}/#{entry}; fi; ln -s #{shared_path}/rails/#{entry} #{release_path}/#{entry}
      CMD
    end
  end
  
  task :symlink_migration_configuration, :roles => :db do
    run <<-CMD
      if [ -f #{current_release}/config/database.yml ]; then rm -f #{current_release}/config/database.yml; fi; ln -s #{shared_path}/rails/config/database.migrate.yml #{current_release}/config/database.yml
    CMD
  end
  
  task :symlink_production_configuration, :roles => :db do
    run <<-CMD
      if [ -f #{current_release}/config/database.yml ]; then rm -f #{current_release}/config/database.yml; fi; ln -s #{shared_path}/rails/config/database.yml #{current_release}/config/database.yml
    CMD
  end
  
end


namespace :deploy do
  namespace :web do
    
    task :disable, :roles => :web, :except => { :no_release => true } do
      
      require 'erb'
      on_rollback { run "rm #{shared_path}/system/maintenance.html" }
      
      template  = File.read(File.join(File.dirname(__FILE__), "..", "public", "maintenance.rhtml"))
      result    = ERB.new(template).result(binding)
      
      put result, "#{shared_path}/system/maintenance.html", :mode => 0644
      
    end
    
    task :enable, :roles => :web, :except => { :no_release => true } do
      run "rm #{shared_path}/system/maintenance.html"
    end
  
  end
end


before  "deploy:migrate",     "deploy:symlink_migration_configuration"
after   "deploy:migrate",     "deploy:symlink_production_configuration"

after   "deploy:update_code", "deploy:update_configuration"

set :stages,        [:beta, :production]
set :default_stage, :beta
require 'capistrano/ext/multistage'
