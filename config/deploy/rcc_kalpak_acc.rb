set :rails_env, :production
set :branch, 'master'
set :sidekiq_env, :production
set :stage, :production

# role [:web, :app, :db], %w{3.111.45.24 15.207.236.182 65.1.121.28 65.1.129.73 3.7.74.115 }, user: 'ubuntu', primary: true
role [:web, :app, :db], %w{ 3.111.34.173 }, user: 'ubuntu', primary: true
