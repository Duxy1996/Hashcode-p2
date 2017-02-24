class Video < ActiveRecord::Base
    has_many :requests
    has_many :endpoints, through: :requests
end