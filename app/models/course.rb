class Course < ActiveRecord::Base
  has_many :teaches
  has_many :users, :through => :teaches
end
