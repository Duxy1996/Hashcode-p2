class Cache < ActiveRecord::Base
    has_many :solutions
    has_many :videos, through: :solutions
    has_many :connections
    has_many :endpoints, through: :connections
end