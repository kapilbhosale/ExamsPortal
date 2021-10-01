set :rails_env, :production
set :branch, 'master'
set :sidekiq_env, :production
set :stage, :production

server '65.2.3.175', user: 'ubuntu', roles: [:web, :app, :db], primary: true
