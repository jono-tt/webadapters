default_environment["PATH"]="/opt/ruby-1.9.2-p290/bin:$PATH"

set :deploy_via, :copy

set :rails_env, :staging

default_run_options[:pty] = true
ssh_options[:forward_agent] = true

set  :servers, %w( your.host.com )
role :app, *servers
role :web, *servers
role :db, *servers.first
role :cron, *servers.first

set :branch, "master"
