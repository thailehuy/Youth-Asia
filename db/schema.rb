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

ActiveRecord::Schema.define(:version => 20100321070859) do

  create_table "contents", :force => true do |t|
    t.text     "volunteer_opp"
    t.string   "video_link"
    t.text     "about_youthsay"
    t.text     "about_youth10"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "db_files", :force => true do |t|
    t.binary "data"
  end

  create_table "events", :force => true do |t|
    t.string   "link"
    t.string   "eid"
    t.string   "category"
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
    t.string   "eid"
  end

  create_table "invitation_counts", :force => true do |t|
    t.string   "uid"
    t.string   "invited_uid"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "tickets", :force => true do |t|
    t.string   "uid"
    t.string   "name"
    t.string   "email"
    t.string   "phone"
    t.string   "ic_number"
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
    t.string   "position_1"
    t.string   "position_2"
    t.string   "position_3"
    t.text     "reason"
    t.string   "content_type"
    t.string   "filename"
    t.string   "thumbnail"
    t.integer  "size"
    t.integer  "width"
    t.integer  "height"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "school",        :default => ""
    t.string   "state",         :default => ""
    t.integer  "db_file_id"
  end

end
