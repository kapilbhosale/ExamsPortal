# app-eduaakr  bhargav  chate  demo  eduaakar-site  exams  videos
set :rails_env, :production
set :branch, 'exam-shuffle'
set :sidekiq_env, :production
set :stage, :production

server '3.108.60.117', user: 'ubuntu', roles: [:web, :app, :db], primary: true
