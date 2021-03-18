set :rails_env, :production
set :branch, 'master'
set :sidekiq_env, :production
set :stage, :production

server '157.90.133.107', user: 'ubuntu', roles: [:web, :app, :db], primary: true
