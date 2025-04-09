set :rails_env, :production
set :branch, 'main'
set :sidekiq_env, :production
set :stage, :production

# small server
# role [:web, :app, :db], %w{ 3.111.34.173 }, user: 'ubuntu', primary: true

# big server - 3.110.191.3, small server - 3.111.34.173
role [:web, :app, :db], %w{ 3.110.191.3 }, user: 'ubuntu', primary: true