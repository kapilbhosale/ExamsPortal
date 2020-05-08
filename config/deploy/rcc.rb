set :rails_env, :production
set :branch, 'develop'
set :sidekiq_env, :production
set :stage, :production

server '35.154.88.190', user: 'ubuntu', roles: [:web, :app, :db], primary: true
