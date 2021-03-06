require 'sinatra'
require 'rack/contrib'
require 'active_record'
require 'json'

require './model/plants'

class FrontendApplication < Sinatra::Base
    get '/' do
        File.open('index.html').read
    end
end

class PlantApplication < Sinatra::Base
    dbconfig = YAML.load(ERB.new(File.read(File.join("config","database.yml"))).result)
    
    configure :development, :test do
        require 'sqlite3'
        ActiveRecord::Base.establish_connection(dbconfig['development'])
    end

    configure :production do
        require 'pg'
        ActiveRecord::Base.establish_connection(dbconfig['production'])
    end

    # use Rack::PostBodyContentTypeParser

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
        
        plant.image = params[:image]

        if plant.save
            [201, "/plants/#{plant['id']}"]
        end
    end

    after do
        ActiveRecord::Base.connection.close
    end
end


