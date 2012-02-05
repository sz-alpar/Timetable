# encoding: UTF-8
# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20120205035718) do

  create_table "course_types", :force => true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "courses", :force => true do |t|
    t.string   "code"
    t.string   "title"
    t.string   "description"
    t.integer  "semester"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "hours", :force => true do |t|
    t.datetime "hours"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "teach_id"
    t.integer  "course_type_id"
    t.integer  "timesheet_id"
  end

  create_table "roles", :force => true do |t|
    t.string   "permission"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "teaches", :force => true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "user_id"
    t.integer  "course_id"
  end

  create_table "timesheets", :force => true do |t|
    t.datetime "start_time"
    t.integer  "repeats"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "hour_id"
  end

  create_table "users", :force => true do |t|
    t.string   "name"
    t.string   "password"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "role_id"
  end

  create_table "wishes", :force => true do |t|
    t.boolean  "to_be_held"
    t.datetime "when"
    t.boolean  "important"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "teach_id"
    t.integer  "hour_id"
  end

end
