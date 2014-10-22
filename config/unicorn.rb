# http://unicorn.bogomips.org/
# https://blog.heroku.com/archives/2013/2/27/unicorn_rails
# http://devblog.thinkthroughmath.com/blog/2013/02/27/managing-request-queuing-with-rails-on-heroku/

listen           ENV['PORT'], backlog: Integer(ENV['UNICORN_BACKLOG'] || 16)
worker_processes Integer(ENV['UNICORN_WORKERS'] || 3)
timeout          15
preload_app      true

before_fork do |server, worker|
  Signal.trap 'TERM' do
    puts 'Unicorn master intercepting TERM and sending myself QUIT instead.'
    Process.kill 'QUIT', Process.pid
  end

  defined?(ActiveRecord::Base) and
    ActiveRecord::Base.connection.disconnect!
end

after_fork do |server, worker|
  Signal.trap 'TERM' do
    puts 'Unicorn worker intercepting TERM and doing nothing. Wait for master to send QUIT.'
  end

  if defined?(ActiveRecord::Base)
    # See https://devcenter.heroku.com/articles/postgis for context.
    config = ActiveRecord::Base.configurations[Rails.env] || Rails.application.config.database_configuration[Rails.env]
    config['adapter'] = 'postgis'
    ActiveRecord::Base.establish_connection(config)
  end
end
