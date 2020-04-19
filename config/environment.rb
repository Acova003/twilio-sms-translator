ENV['SINATRA_ENV'] ||= "development"

require 'bundler/setup'
Bundler.require(:default, ENV['SINATRA_ENV'])

require 'yaml'
env = YAML.load_file("./config/authentification_details.yaml")[ENV['SINATRA_ENV']]
env.each do |key, value|
  ENV[key] = value
end

puts "*" * 80
puts "environment"
puts ENV

ActiveRecord::Base.establish_connection(
  :adapter => "sqlite3",
  :database => "db/#{ENV['SINATRA_ENV']}.sqlite"
)

require './app/controllers/application_controller'
require_all 'app'
