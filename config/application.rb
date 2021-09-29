require_relative 'boot'

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module Qna
  class Application < Rails::Application
    config.load_defaults 6.1
    config.active_storage.replace_on_assign_to_many = false
    config.active_job.queue_adapter = :sidekiq

    config.generators do |g|
      g.test_framework :rspec,
                       controller_specs: true,
                       request_specs: false,
                       view_specs: false,
                       routing_specs: false,
                       helper_specs: false
    end
  end
end
