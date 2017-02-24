class Endpoint
    has_many :requests
    has_many :videos, through: :requests

    has_many :connections
    has_many :caches, through: :connections
end