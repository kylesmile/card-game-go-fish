require 'sass/plugin/rack'
require './go_fish_app'

Sass::Plugin.options[:style] = :compressed
use Sass::Plugin::Rack

run Sinatra::Application
