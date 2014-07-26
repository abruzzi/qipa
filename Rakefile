require 'active_record'
require 'yaml'
require 'logger'

task :default => :migrate

desc "Migrate the database through scripts in db/."
task :migrate => :environment do
    ActiveRecord::Migrator.migrate('db/', ENV["VERSION"] ? ENV["VERSION"].to_i : nil )
end

task :environment do
    ActiveRecord::Base.establish_connection(YAML::load(File.open('config/database.yml'))['production'])
    ActiveRecord::Base.logger = Logger.new(File.open('database.log', 'a'))
end
