#!/usr/bin/env puma

# Workers and connections.
threads 1
workers 1
bind "tcp://127.0.0.1:3000"
environment "production"

# Copy on write.
preload_app!

on_worker_boot do
  ActiveSupport.on_load(:active_record) do
    ActiveRecord::Base.establish_connection
  end
end
