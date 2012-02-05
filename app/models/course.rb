class Course < ActiveRecord::Base
  has_many :teaches, :dependent => :destroy
  has_many :users, :through => :teaches
end
