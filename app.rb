require 'sinatra'
require 'rack/contrib'
require 'active_record'
require 'json'

require 'pg'

require './model/plants'

dbconfig = YAML.load(ERB.new(File.read(File.join("config","database.yml"))).result)
ActiveRecord::Base.establish_connection(dbconfig['production'])

use Rack::PostBodyContentTypeParser

get '/plants' do
    plants = Plant.all || []
    plants.to_json
end

get '/plants/:id' do
    plant = Plant.find(params[:id])
    plant.to_json 
end

post '/plants' do
    plant = Plant.create(:name => params[:name],
                        :description => params[:description],
                        :created_at => Time.now,
                        :updated_at => Time.now)
    
    if plant.save
        [201, "/plants/#{plant['id']}"]
    end
end
