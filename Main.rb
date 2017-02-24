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
        l = f.readline.split.map{|x| x.to_i}
        V, E, R, C, X = l
        
        l = []
        f.readlines.each do |line|
            line.split.each do |i|
                l << i.to_i
            end
        end
        V.times do
            Video.new(size: l.shift).save
        end
        
        C.times do 
            Cache.new(size: X).save
        end

        E.times do
            e = Endpoint.new(lat: l.shift)
            e.save
            l.shift.times do
                e.connections << Connection.new(cache_id: l.shift + 1, lat: l.shift)
            end
        end

        R.times do
            v = Video.find(l.shift + 1)
            v.requests << Request.new(endpoint_id: l.shift + 1, count: l.shift)
        end

        puts "#{Video.all.count} videos"
        puts "#{Cache.all.count} cache servers"
        puts "#{Endpoint.all.count} endpoints"
        Endpoint.all.each do |e|
            e.connections.each do |c|
                puts "Endpoint #{e.id-1} is connected to cache server #{c.cache_id-1}"
            end
        end
        puts "#{Video.all.count} videos"
        Video.all.each do |v|
            v.requests.each do |r|
                puts "Video #{v.id-1} is requested in endpoint #{r.endpoint_id-1} (#{r.count} times)"
            end
        end
    end
end