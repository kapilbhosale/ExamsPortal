# dscl exam server
# cap dscl-exam-server deploy
set :rails_env, :production
set :branch, 'master'
set :sidekiq_env, :production
set :stage, :production

server '13.235.84.81', user: 'ubuntu', roles: [:web, :app, :db], primary: true
