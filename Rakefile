require 'active_record'
require 'erb'
require 'yaml'
require 'logger'

desc "Migrate the database through scripts in db/."
task :migrate => :environment do
    ActiveRecord::Migrator.migrate('db/', ENV["VERSION"] ? ENV["VERSION"].to_i : nil )
end

task :environment do
    dbconfig = YAML.load(ERB.new(File.read(File.join("config","database.yml"))).result)
    env = ENV["RACK_ENV"]
    ActiveRecord::Base.establish_connection(dbconfig[env])
    ActiveRecord::Base.logger = Logger.new(File.open('database.log', 'a'))
end

if ENV["RACK_ENV"] == 'development'
	require 'rspec/core/rake_task'

	RSpec::Core::RakeTask.new :specs do |task|
		task.pattern = Dir['spec/**/*_spec.rb']
	end

	task :default => ['specs']
end

task :default => ['migrate']