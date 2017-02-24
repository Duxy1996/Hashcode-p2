require 'active_record'
require 'yaml'
require 'require_all'
require 'pp'
require_all 'models/*.rb'

class Main
    db_config = YAML::load(File.open('config/database.yml'))['default']
    ActiveRecord::Base.establish_connection(db_config)

    #initial parsing
    File.open(ARGV[0], "r") do |f|
        l = f.readline.split
        V, E, R, C, X = l
        puts V, E, R, C, X
    end
end