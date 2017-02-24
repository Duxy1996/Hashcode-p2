class Solution < ActiveRecord::Base
    belongs_to :video
    belongs_to :cache
end