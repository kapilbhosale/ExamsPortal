# Adhyayan+jalna+epa+mpsc+nijc
<<<<<<< HEAD
# epa  exams  jalna  jnc-science-clg  mpsc  nijc  videos
=======
>>>>>>> origin/roles-changes
set :rails_env, :production
set :branch, 'main_branch'
set :sidekiq_env, :production
set :stage, :production

server '13.232.220.48', user: 'ubuntu', roles: [:web, :app, :db], primary: true
