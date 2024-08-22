# SmartExamsV2 => ["stark", "kcp", "hostel", "jmc", "bhargav", "gp_dhule", "jspm", "vaa", "sri-gosalites", "demo", "srbio", "elearning", "dscl", "tf", "bansalclasses", "annapurnaacademy", "sstl", "lbs", "chate", "mps", "infinity", "kota", "konale-exams", "pis"]
# SmartExamsV3 => ["dayanand", "munde", "yashwant-clg-backup", "wagaj", "scholars", "ganesh", "bhosale"]
# SmartExamsV4 => ["vaa", "hostel", "jmc", "bhargav", "chate", "gp_dhule", "jspm", "konale-exams", "demo", "srbio", "elearning", "kcp", "lbs", "tf", "bansalclasses", "dscl"]
# SmartExamsV5 => ["bep", "saraswati-videos", "saraswati-exams", "dep"]

set :application, "SmartExamsV2"
set :repo_url, "git@github.com:akshaymohite/SmartExamsRails.git"
set :user, 'ubuntu'
set :deploy_to,   "/home/#{fetch(:user)}/app/#{fetch(:application)}"

set :rails_env, :production
# Don't change these unless you know what you're doing
set :pty,             true
set :use_sudo,        false
set :stage,           :production
set :deploy_via,      :remote_cache
set :ssh_options,     { forward_agent: true }
set :puma_init_active_record, true  # Change to false when not using ActiveRecord
set :rvm_ruby_version, 'ruby-2.5.1@smart-exams'

set :keep_releases, 5

set :linked_dirs, fetch(:shared_dirs, []).push('log', 'tmp/pids', 'tmp/sockets', 'public/uploads')
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
      unless `git rev-parse HEAD` == `git rev-parse origin/master-aws-migration`
        puts "WARNING: HEAD is not the same as origin/master-aws-migration"
        puts "Run `git push` to sync changes."
        exit
      end
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

  desc 'PumaV2 Restart'
  task :puma_restart do
    on roles(:app) do
      within release_path do
        execute("sudo service puma_v2 restart")
      end
    end
  end

  desc 'SidekiqV2 Restart'
  task :sidekiq_restart do
    on roles(:app) do
      within release_path do
        execute("sudo service sidekiq_v2 restart")
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
  # after  :compile_assets, :webpack_compile

  before :starting,     :check_revision
  after  :finishing,    :compile_assets
  after  :finishing,    :cleanup
  after  :finishing,    :restart
  # after  :restart,      :sidekiq_restart
  # after  :restart,      :puma_restart

end

# sudo vi /etc/resolv.conf
# sudo systemctl restart systemd-resolved.service