set :application, "SmartExams"
set :repo_url, "git@github.com:kapilbhosale/ExamsPortal.git"
set :user, 'ubuntu'

set :rails_env, :production
# Don't change these unless you know what you're doing
set :pty,             true
set :use_sudo,        false
set :stage,           :production
set :deploy_via,      :remote_cache
set :deploy_to,       "/home/#{fetch(:user)}/app/#{fetch(:application)}"
set :puma_bind,       "unix://#{shared_path}/tmp/sockets/#{fetch(:application)}-puma.sock"
set :puma_state,      "#{shared_path}/tmp/pids/puma.state"
set :puma_pid,        "#{shared_path}/tmp/pids/puma.pid"
set :puma_access_log, "#{release_path}/log/puma.error.log"
set :puma_error_log,  "#{release_path}/log/puma.access.log"
set :ssh_options,     { forward_agent: true }
set :puma_preload_app, true
set :puma_worker_timeout, nil
set :puma_init_active_record, true  # Change to false when not using ActiveRecord
set :rvm_ruby_version, 'ruby-2.5.1@smart-exams'

set :keep_releases, 5

set :linked_dirs, fetch(:shared_dirs, []).push('log', 'tmp/pids', 'tmp/sockets', 'public/uploads', 'zip_data')
set :linked_files, fetch(:shared_files, []).push(
  'config/database.yml',
  'config/sidekiq.yml',
  'config/secrets.yml',
  'config/puma.rb',
  'config/application.yml')

set :sidekiq_roles, :app
# set :sidekiq_default_hooks, false
# ensure this path exists in production before deploying.
set :sidekiq_pid, File.join(shared_path, 'tmp', 'pids', 'sidekiq.pid')
set :sidekiq_env, fetch(:rack_env, fetch(:rails_env, fetch(:stage)))
set :sidekiq_log, File.join(shared_path, 'log', 'sidekiq.log')
set :sidekiq_config, "#{current_path}/config/sidekiq.yml"

set :default_shell, '/bin/bash -l'

namespace :puma do
  desc 'Create Directories for Puma Pids and Socket'
  task :make_dirs do
    on roles(:app) do
      execute "mkdir #{shared_path}/tmp/sockets -p"
      execute "mkdir #{shared_path}/tmp/pids -p"
    end
  end

  # before :start, :make_dirs
end

namespace :deploy do
  desc "Make sure local git is in sync with remote."
  task :check_revision do
    on roles(:app) do
      unless `git rev-parse HEAD` == `git rev-parse origin/master`
        puts "WARNING: HEAD is not the same as origin/master"
        puts "Run `git push` to sync changes."
        exit
      end
    end
  end
  
  desc 'Initial Deploy'
  task :initial do
    on roles(:app) do
      before 'deploy:restart', 'puma:start'
      invoke 'deploy'
    end
  end

  desc 'Run rake yarn:install'
  task :yarn_install do
    on roles(:web) do
      within release_path do
        execute("cd #{release_path} && yarn install")
      end
    end
  end

  desc 'Restart application'
  task :restart do
    on roles(:app), in: :sequence, wait: 5 do
      invoke 'puma:restart'
    end
  end

  desc 'Sidekiq Restart'
  task :sidekiq_restart do
    on roles(:app) do
      within release_path do
        execute("sudo service sidekiq restart")
      end
    end
  end

  desc 'Webpack Compiling assets'
  task :webpack_compile do
    on roles(:app) do
      within release_path do
        # execute("NODE_ENV=production ./bin/webpack")
        execute :rake, "webpacker:compile"
      end
    end
  end

  before "deploy:assets:precompile", "deploy:yarn_install"
  after  :compile_assets, :webpack_compile

  before :starting,     :check_revision
  after  :finishing,    :compile_assets
  after  :finishing,    :cleanup
  after  :finishing,    :restart
  after  :restart,      :sidekiq_restart

end

# sudo vi /etc/resolv.conf
# sudo systemctl restart systemd-resolved.service