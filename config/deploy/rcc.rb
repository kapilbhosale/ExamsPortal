set :rails_env, :production
set :branch, 'rcc-payment'
set :sidekiq_env, :production
set :stage, :production

server '13.126.111.72', user: 'ubuntu', roles: [:web, :app, :db], primary: true
