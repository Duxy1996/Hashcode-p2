class Video
    has_many :requests
    has_many :endpoints, through: :requests
end