$:.unshift(File.expand_path('./lib', ENV['rvm_path']))
require 'rvm/capistrano'

set :rvm_ruby_string, "ree@services"
set :rvm_type,        :user

set :application, "services"
set :repository,  "http://github.com/seanchas/services.git"
set :user,        :ror
set :runner,      :ror
set :use_sudo,    false

set :deploy_to,   "/export/depo/ror/linux/appservers/#{application}"
set :deploy_via,  :copy

set :scm, :git

role :web, "blis1"
role :app, "blis1"
role :db,  "blis1", :primary => true

#set :bundle_cmd,  "/opt/gnu/ror/bin/bundle"
#set :bundle_dir, "#{release_path}/vendor/bundle"

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

namespace :bundler do
  
  task :update, :roles => :app do
    run <<-CMD
      cd #{current_release} && bundle install
    CMD
  end
  
end

before  "deploy:migrate",     "deploy:symlink_migration_configuration"
after   "deploy:migrate",     "deploy:symlink_production_configuration"

after   "deploy:update_code", "deploy:update_configuration"#, "bundler:update"
