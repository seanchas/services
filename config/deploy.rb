set :application, "services"
set :repository,  "http://github.com/seanchas/services.git"
set :user,        :ror
set :runner,      :ror
set :use_sudo,    false

set :deploy_to,   "/export/depo/ror/linux/appservers/#{application}"
set :deploy_via,  :copy

set :scm, :git
set :scm_verbose, :false

role :web, "blis1"
role :app, "blis1"
role :db,  "blis1", :primary => true

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
  'config/locales/ru.yml',
  'vendor/rails'
]

namespace :deploy do

  task :update_configuration, :roles => :app do
    configuration.each do |entry|
      run <<-CMD
        if [ -f #{release_path}/#{entry} ]; then rm -f #{release_path}/#{entry}; fi; ln -s #{shared_path}/rails/#{entry} #{release_path}/#{entry}
      CMD
    end
  end
  
end

after "deploy:update_code", "deploy:update_configuration"
