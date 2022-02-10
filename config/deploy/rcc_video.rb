set :rails_env, :production
set :branch, 'master'
set :sidekiq_env, :production
set :stage, :production

server '65.0.116.185', user: 'ubuntu', roles: [:web, :app, :db], primary: true
# This server is only for video link fetching.
