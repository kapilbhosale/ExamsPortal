# Adhyayan+jalna+epa+mpsc+nijc
# epa  exams  jalna  jnc-science-clg  mpsc  nijc  videos
set :rails_env, :production
set :branch, 'main_branch'
set :sidekiq_env, :production
set :stage, :production

server '13.232.112.73', user: 'ubuntu', roles: [:web, :app, :db], primary: true