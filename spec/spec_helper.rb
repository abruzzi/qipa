ENV['RACK_ENV'] = 'test'

require 'rspec'
require 'rack/test' 
require 'database_cleaner'

require_relative File.join('..', 'app')

RSpec.configure do |config|
  include Rack::Test::Methods

  config.color = true
  config.tty = true
  
  config.before(:suite) do
    DatabaseCleaner.strategy = :transaction
    DatabaseCleaner.clean_with(:truncation)
  end

  config.around(:each) do |example|
    DatabaseCleaner.cleaning do
      example.run
    end
  end

  def app
    PlantApplication
  end
  
end