class Teach < ActiveRecord::Base
  belongs_to :user
  belongs_to :course
  has_many :hours
  has_many :wishes
end
