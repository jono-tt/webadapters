set :user, "appserver"

default_environment["PATH"]="/opt/ruby-1.9.2-p290/bin:$PATH"

set :deploy_via, :copy

set :rails_env, :production

default_run_options[:pty] = true
ssh_options[:forward_agent] = true

set  :servers, %w( production1.host.com production2.host.com production3.host.com )
role :app, *servers
role :web, *servers
role :db, *servers.first
role :cron, *servers.first

set :branch, "deploy"
