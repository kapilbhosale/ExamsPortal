set :rails_env, :production
set :branch, 'master'
set :sidekiq_env, :production
set :stage, :production

# server '13.126.111.72', user: 'ubuntu', roles: [:web, :app, :db], primary: true
role [:web, :app, :db], %w{13.233.91.212 65.1.167.12}, user: 'ubuntu', primary: true
