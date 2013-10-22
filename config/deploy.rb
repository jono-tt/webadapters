require 'bundler/capistrano'
require 'capistrano/ext/multistage'
load 'deploy/assets'

set :user, "appserver"
set :application, "webadapter2"
set :repository, "git@github.com:mitadmin/webadapter2.git"

set :resque_count, 2

set :scm, :git

set :deploy_to, "/opt/railsapps/applications/#{application}"

set :default_stage, :autodeploy

namespace :deploy do
  task :restart do
    run "touch #{current_path}/tmp/restart.txt"
  end

  task :link_config_files do
    %w{database.yml redis.yml footprints.yml}.each do |config|
      config_file = "#{release_path}/config/#{config}"
      shared_config_file = "#{shared_path}/config/#{config}"
      run "test -f #{config_file} && rm #{config_file}; ln -s #{shared_config_file} #{config_file}"
    end
  end
end

namespace :db do
  task :migrate, :roles => :db do
    run "cd #{current_path} && bundle exec rake db:migrate --trace RAILS_ENV=#{rails_env}"
  end

  task :seed do
    run "cd #{current_path} && bundle exec rake db:seed RAILS_ENV=#{rails_env}"
  end
end

namespace :foreman do
  desc "Export the Procfile to Ubuntu's upstart scripts"
  task :export, :roles => :app do
    run "cd #{current_path} && sudo bundle exec foreman export upstart /etc/init -f Procfile.#{rails_env} -a #{application} -u #{user} -l #{shared_path}/log -c resque=#{resque_count},resque_web=1"
  end

  desc "Start the application services"
  task :start, :roles => :app do
    sudo "start #{application}"
  end

  desc "Stop the application services"
  task :stop, :roles => :app do
    sudo "stop #{application}"
  end

  desc "Restart the application services"
  task :restart, :roles => :app do
    run "sudo start #{application} || sudo restart #{application}"
  end
end

before "deploy:assets:precompile", "deploy:link_config_files"
before "deploy:restart", "db:migrate"
