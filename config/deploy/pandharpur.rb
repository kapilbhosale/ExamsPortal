set :rails_env, :production
set :branch, 'rcc-payment'
set :sidekiq_env, :production
set :stage, :production

server '15.206.148.218', user: 'ubuntu', roles: [:web, :app, :db], primary: true
