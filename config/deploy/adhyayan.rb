set :rails_env, :production
set :branch, 'develop'
set :sidekiq_env, :production
set :stage, :production

server '13.232.220.48', user: 'ubuntu', roles: [:web, :app, :db], primary: true
