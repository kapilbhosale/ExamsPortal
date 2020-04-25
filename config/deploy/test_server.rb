set :rails_env, :production
set :branch, 'release'
set :sidekiq_env, :production
set :stage, :production

server '13.235.19.68', user: 'ubuntu', roles: [:web, :app, :db], primary: true
