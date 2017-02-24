class Cache < ActiveRecord::Base
    has_many :videos
    has_many :connections
    has_many :endpoints, through: :connections
end