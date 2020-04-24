set :rails_env, :production
set :branch, 'release'
set :sidekiq_env, :production
set :stage, :production

server '52.66.253.105', user: 'ubuntu', roles: [:web, :app, :db], primary: true
