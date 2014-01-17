require_relative '../../go_fish_app'
require 'rspec/expectations'
require 'spinach/capybara'
require 'capybara/poltergeist'

Spinach::FeatureSteps.send(:include, Spinach::FeatureSteps::Capybara)
Capybara.app = GoFishApp

require_relative './extra_commands'