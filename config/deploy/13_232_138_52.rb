# cap 13_232_138_52 deploy
# 13.232.138.52
# bhsl+ganehs+munde+scholar+wagaj+yashwant+epa
# bhosale  dayanand  ganesh  munde  scholars  waghaj  yashwant
set :rails_env, :production
set :branch, 'main_branch'
set :sidekiq_env, :production
set :stage, :production

server '13.232.138.52', user: 'ubuntu', roles: [:web, :app, :db], primary: true
