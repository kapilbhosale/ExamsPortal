# app-eduaakr  bhargav  chate  demo  eduaakar-site  exams  videos
set :rails_env, :production
set :branch, 'master'
set :sidekiq_env, :production
set :stage, :production

server '13.126.87.94', user: 'ubuntu', roles: [:web, :app, :db], primary: true
