require 'sinatra'
require 'rack/contrib'
require 'active_record'
require 'json'

require 'pg'
require 'sqlite3'

require './model/plants'

class PlantApplication < Sinatra::Base
    dbconfig = YAML.load(ERB.new(File.read(File.join("config","database.yml"))).result)
    
    configure :development do
        ActiveRecord::Base.establish_connection(dbconfig['development'])
    end

    configure :production do
        ActiveRecord::Base.establish_connection(dbconfig['production'])
    end

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
end


