class Request < ActiveRecord::Base
    belongs_to :video
    belongs_to :endpoint
end