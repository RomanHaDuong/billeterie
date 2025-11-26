# Puma configuration for production

max_threads_count = ENV.fetch("RAILS_MAX_THREADS") { 5 }
min_threads_count = ENV.fetch("RAILS_MIN_THREADS") { max_threads_count }
threads min_threads_count, max_threads_count

rails_env = ENV.fetch("RAILS_ENV") { "production" }
environment rails_env

# Bind to Unix socket
bind "unix:///home/roman/apps/billeterie/shared/tmp/sockets/puma.sock"

# Process IDs
pidfile "/home/roman/apps/billeterie/shared/tmp/pids/puma.pid"
state_path "/home/roman/apps/billeterie/shared/tmp/pids/puma.state"

# Logging
stdout_redirect "/home/roman/apps/billeterie/shared/log/puma_access.log", "/home/roman/apps/billeterie/shared/log/puma_error.log", true

# Set number of workers (adjust based on CPU cores)
workers ENV.fetch("WEB_CONCURRENCY") { 2 }

# Preload application for better performance
preload_app!

# Allow puma to be restarted by systemctl
plugin :tmp_restart

on_worker_boot do
  ActiveRecord::Base.establish_connection if defined?(ActiveRecord)
end

before_fork do
  ActiveRecord::Base.connection_pool.disconnect! if defined?(ActiveRecord)
end
