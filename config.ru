require File.dirname(__FILE__) + '/app'

run Rack::Cascade.new [PlantApplication, FrontendApplication]
