set :rails_env, :production
set :branch, 'master'
set :sidekiq_env, :production
set :stage, :production

server '103.224.245.55', user: 'ubuntu', roles: [:web, :app, :db], primary: true
