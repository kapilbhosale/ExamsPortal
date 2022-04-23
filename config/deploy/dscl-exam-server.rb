# dscl exam server
# cap dscl-exam-server deploy
set :rails_env, :production
set :branch, 'master'
set :sidekiq_env, :production
set :stage, :production

server '15.206.188.116', user: 'ubuntu', roles: [:web, :app, :db], primary: true
