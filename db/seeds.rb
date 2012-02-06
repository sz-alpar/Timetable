# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

role = Role.create(:permission => 'admin')
user = User.create(:name => 'admin', :password => '1234')
user.role = role
user.save

role2 = Role.create(:permission => 'teacher')
user2 = User.create(:name => 'teacher', :password => '1234')
user2.role = role2
user2.save

CourseType.create(:name => "Lecture")
CourseType.create(:name => "Lab")
CourseType.create(:name => "Seminar")

tought_courses_per_week = (0..30).to_a
6.times do |i|
  5.times do |j|
    start_time = 8 + (tought_courses_per_week[j*6 + i] % 6)*2 + j*24
    start_time = start_time * 3600
    timesheet = Timesheet.create(:start_time => Time.at(start_time).gmtime)
    timesheet.save  
  end
end
