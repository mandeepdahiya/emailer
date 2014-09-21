require 'rubygems'
require 'mysql'
require 'active_record'
require 'logger'
dbconfig = YAML::load(File.open('database.yml'))
ActiveRecord::Base.establish_connection(dbconfig)
ActiveRecord::Base.logger = Logger.new(STDERR)
