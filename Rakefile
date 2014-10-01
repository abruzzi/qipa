require 'active_record'
require 'erb'
require 'yaml'
require 'logger'

task :default => :migrate

desc "Migrate the database through scripts in db/."
task :migrate => :environment do
    ActiveRecord::Migrator.migrate('db/', ENV["VERSION"] ? ENV["VERSION"].to_i : nil )
end

task :environment do
    dbconfig = YAML.load(ERB.new(File.read(File.join("config","database.yml"))).result)
    env = ENV["ENV"] ? ENV["ENV"] : 'production'
    ActiveRecord::Base.establish_connection(dbconfig[env])
    ActiveRecord::Base.logger = Logger.new(File.open('database.log', 'a'))
end
