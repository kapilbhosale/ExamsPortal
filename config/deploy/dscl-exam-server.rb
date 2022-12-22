# dscl exam server
# cap dscl-exam-server deploy
set :rails_env, :production
set :branch, 'master'
set :sidekiq_env, :production
set :stage, :production

server '13.234.115.187', user: 'ubuntu', roles: [:web, :app, :db], primary: true
