# app-eduaakr  bhargav  chate  demo  eduaakar-site  exams  videos
set :rails_env, :production
<<<<<<< HEAD
set :branch, 'main_branch'
=======
set :branch, 'roles-changes'
>>>>>>> origin/roles-changes
set :sidekiq_env, :production
set :stage, :production

server '13.126.87.94', user: 'ubuntu', roles: [:web, :app, :db], primary: true
