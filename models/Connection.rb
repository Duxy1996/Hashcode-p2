class Connection < ActiveRecord::Base
    belongs_to :cache
    belongs_to :endpoint
end