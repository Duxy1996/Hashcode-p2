class Video < ActiveRecord::Base
    has_many :solutions
    has_many :caches, through: :solutions, source: :cache
    has_many :requests
    has_many :endpoints, through: :requests
end