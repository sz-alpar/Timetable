class User < ActiveRecord::Base
  # one-to-many association, the foreign key pointing to the Role table row is kept in this table
  # read for details: 
  # http://guides.rubyonrails.org/association_basics.html 
  # http://duanesbrain.blogspot.com/2006/05/ruby-on-rails-hasone-versus-belongsto.html
  belongs_to :role
  has_many :teaches
  has_many :courses, :through => :teaches
end
