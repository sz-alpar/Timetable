class Hour < ActiveRecord::Base
  belongs_to :teach
  belongs_to :course_type
end
