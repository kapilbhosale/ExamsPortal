set :rails_env, :production
set :branch, 'release'
set :sidekiq_env, :production
set :stage, :production

server 'api.examapp.in', user: 'ubuntu', roles: [:web, :app, :db], primary: true
