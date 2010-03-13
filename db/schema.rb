# This file is auto-generated from the current state of the database. Instead of editing this file, 
# please use the migrations feature of Active Record to incrementally modify your database, and
# then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your database schema. If you need
# to create the application database on another system, you should be using db:schema:load, not running
# all the migrations from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20100312125058) do

  create_table "events", :force => true do |t|
    t.string   "link"
    t.string   "eid"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "features", :force => true do |t|
    t.string   "eid"
    t.string   "f_type"
    t.string   "event_link"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "gatherings", :force => true do |t|
    t.string   "name"
    t.string   "affiliation"
    t.datetime "date_of_birth"
    t.string   "address"
    t.string   "email"
    t.string   "phone"
    t.string   "race"
    t.string   "ic_number"
    t.string   "event_link"
    t.string   "uid"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "invitation_counts", :force => true do |t|
    t.string   "uid"
    t.integer  "counter"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "volunteers", :force => true do |t|
    t.string   "uid"
    t.string   "name"
    t.string   "affiliation"
    t.string   "email"
    t.string   "phone"
    t.string   "date_of_birth"
    t.string   "address"
    t.string   "race"
    t.string   "ic_number"
    t.text     "reason"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
