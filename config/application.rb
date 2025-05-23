require_relative 'boot'

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module SmartExamsRails
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 5.2

    config.time_zone = 'Chennai'
    config.active_record.default_timezone = :local

    config.middleware.insert_after ActionDispatch::Static, Rack::Deflater
    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration can go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded after loading
    # the framework and any gems in your application.
    config.autoload_paths += Dir[Rails.root.join('lib', 'tasks', '**/'), Rails.root.join('lib', '**/')]
    config.assets.paths << Rails.root.join("app", "assets", "fonts")

  end
end
