# config valid for current version and patch releases of Capistrano
lock "~> 3.19.2"

set :application, "billeterie"
set :repo_url, "git@github.com:RomanHaDuong/billeterie.git"

# Default branch is :master
set :branch, 'master'

# Deploy to directory on Raspberry Pi
set :deploy_to, "/home/roman/apps/billeterie"

# RVM settings
set :rvm_type, :user
set :rvm_ruby_version, '3.3.5'

# Files that need to be symlinked to shared directory
append :linked_files, "config/database.yml", "config/master.key", "config/puma.rb", ".env"

# Directories that should be shared between releases
append :linked_dirs, "log", "tmp/pids", "tmp/cache", "tmp/sockets", "public/system", "vendor", "storage"

# Keep last 5 releases
set :keep_releases, 5

# Puma settings
set :puma_bind, "unix://#{shared_path}/tmp/sockets/puma.sock"
set :puma_state, "#{shared_path}/tmp/pids/puma.state"
set :puma_pid, "#{shared_path}/tmp/pids/puma.pid"
set :puma_access_log, "#{shared_path}/log/puma.access.log"
set :puma_error_log, "#{shared_path}/log/puma.error.log"
set :puma_preload_app, true
set :puma_worker_timeout, nil
set :puma_init_active_record, true
set :puma_enable_socket_service, true

# Namespace for tasks
namespace :deploy do
  desc 'Restart application'
  task :restart do
    invoke 'puma:restart'
  end

  after :publishing, :restart
end
