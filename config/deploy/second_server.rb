# app-eduaakr  bhargav  chate  demo  eduaakar-site  exams  videos
set :application, "SmartExamsV2"
set :deploy_to,   "/home/#{fetch(:user)}/app/SmartExamsV2"
set :rails_env, :production
set :branch, 'master-aws-migration'
set :sidekiq_env, :production
set :stage, :production

# aws server
# server '3.108.60.117', user: 'ubuntu', roles: [:web, :app, :db], primary: true
# pune server
server '103.224.243.149', user: 'ubuntu', roles: [:web, :app, :db], primary: true
