class Wish < ActiveRecord::Base
  belongs_to :teaches
  belongs_to :hour
end
