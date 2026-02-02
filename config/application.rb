require_relative "boot"
require "rails/all"

Bundler.require(*Rails.groups)

module CrudApi
  class Application < Rails::Application
    config.load_defaults 7.1
    config.autoload_lib(ignore: %w(assets tasks))
    
    # API-only mode
    config.api_only = true
    
    # Use Sidekiq for background jobs
    config.active_job.queue_adapter = :sidekiq
  end
end
