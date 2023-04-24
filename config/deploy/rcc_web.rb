set :rails_env, :production
set :branch, 'master'
set :sidekiq_env, :production
set :stage, :production

# server '13.126.111.72', user: 'ubuntu', roles: [:web, :app, :db], primary: true
# role [:web, :app, :db], %w{13.233.91.212 3.111.45.24 65.0.69.34 3.110.110.135 52.66.220.42 15.206.208.54 13.235.53.158}, user: 'ubuntu', primary: true
# role [:web, :app, :db], %w{3.111.45.24 65.0.81.61 43.205.99.45}, user: 'ubuntu', primary: true
role [:web, :app, :db], %w{3.111.45.24}, user: 'ubuntu', primary: true
