require_relative 'boot'

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module Untitled3
  class Application < Rails::Application
    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.
    config.i18n.default_locale = :zh
    config.i18n.locale = :zh
    # Configure the default encoding used in templates for Ruby 1.9.
    config.encoding = "utf-8"
    config.active_record.default_timezone = :local
    config.time_zone = 'Beijing'
  end
end
