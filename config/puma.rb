# frozen_string_literal: true

workers ENV.fetch('WEB_CONCURRENCY', 2)
threads_count = ENV.fetch('RAILS_MAX_THREADS', 5)
threads threads_count, threads_count

preload_app!

# Support IPv6 by binding to host `::` instead of `0.0.0.0`
port(ENV.fetch('PORT', 3000), '::')
environment ENV.fetch('RAILS_ENV', 'development')

# Allow puma to be restarted by `rails restart` command.
plugin :tmp_restart
