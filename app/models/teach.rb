class Teach < ActiveRecord::Base
  belongs_to :user
  belongs_to :course, :dependent => :destroy
  has_many :hours, :dependent => :destroy
  has_many :wishes, :dependent => :destroy
end
