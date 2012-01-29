class Hour < ActiveRecord::Base
  belongs_to :teaches
  belongs_to :course_type
end
