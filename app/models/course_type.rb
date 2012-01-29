class CourseType < ActiveRecord::Base
  has_many :hours
  has_many :teaches, :through => :hours
end
