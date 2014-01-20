require_relative '../../go_fish_app'
require 'rspec/expectations'
require 'spinach/capybara'
require 'capybara/poltergeist'

Spinach::FeatureSteps.send(:include, Spinach::FeatureSteps::Capybara)
Capybara.app = GoFishApp

Capybara.javascript_driver = :poltergeist

Spinach.hooks.on_tag("javascript") do
  ::Capybara.current_driver = ::Capybara.javascript_driver
end

Spinach.hooks.before_scenario do
  GoFishApp.reset
end

Spinach.hooks.after_scenario do
  ::Capybara.reset_sessions!
  ::Capybara.use_default_driver
end

require_relative './extra_commands'