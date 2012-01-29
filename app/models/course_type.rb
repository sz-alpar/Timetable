class CourseType < ActiveRecord::Base
  has_many :hours
end
