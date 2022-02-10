set :rails_env, :production
set :branch, 'master'
set :sidekiq_env, :production
set :stage, :production

# server '13.126.111.72', user: 'ubuntu', roles: [:web, :app, :db], primary: true
role [:web, :app, :db], %w{13.234.75.40 3.110.68.146 3.110.146.65 3.110.65.133}, user: 'ubuntu', primary: true
