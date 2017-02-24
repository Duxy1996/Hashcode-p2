require 'active_record'
require 'yaml'
require 'require_all'
require 'pp'
require 'rake'
require_all 'models/*.rb'

class Main

    #clear DB betweeng calls
    File.delete('db/database.db') if File.exist?('db/database.db')
    Rake.load_rakefile('Rakefile') 
    Rake::Task[ 'db:migrate' ].invoke

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
                c = Cache.find(l.shift + 1)
                cn = Connection.new(lat: l.shift)
                cn.save
                c.connections << cn
                e.connections << cn
            end
        end

        R.times do
            v = Video.find(l.shift + 1)
            e = Endpoint.find(l.shift + 1)
            r = Request.new(count: l.shift)
            r.save
            v.requests << r
            e.requests << r
        end
        
        if(ARGV[1] == "-v")
            puts "#{Video.all.count} videos"
            puts "#{Cache.all.count} cache servers"
            puts "#{Endpoint.all.count} endpoints"
            Endpoint.all.each do |e|
                e.connections.each do |c|
                    puts "Endpoint #{e.id-1} is connected to cache server #{c.cache.id-1}"
                end
            end
            puts "#{Video.all.count} videos"
            Video.all.each do |v|
                v.requests.each do |r|
                    puts "Video #{v.id-1} is requested in endpoint #{r.endpoint.id-1} (#{r.count} times)"
                end
            end
        end
    end

    #find the best combination
    Endpoint.all.each do |endpoint|
        Video.all.order(size: :desc).each do |video|
            endpoint.connections.order(lat: :asc).each do |connection|
                if(connection.cache.size >= video.size and not connection.cache.videos.include? video)
                    connection.cache.videos << video
                    connection.cache.size -= video.size
                    connection.cache.save
                    break
                end
            end
        end
    end

    #try to fill the gaps
    Video.all.order(size: :desc).each do |video|
        Cache.all.each do |cache|
            if(cache.size >= video.size and not cache.videos.include? video)
                cache.videos << video
                cache.size -= video.size
                cache.save
                break
            end
        end
    end

    open("#{ARGV[0][0...-3]}.out", 'w') do |file| 
        file.puts(Cache.joins(:videos).group('caches.id').length)
        Cache.joins( :videos ).group( 'caches.id').each do |cache|
            file << "#{cache.id-1}"
            cache.videos.all.map{|x| x.id-1}.each do |video|
                file << " #{video}"
            end
            file << "\n"
        end
    end
end