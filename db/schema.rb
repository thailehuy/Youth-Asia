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

ActiveRecord::Schema.define(:version => 23) do

  create_table "categories", :force => true do |t|
    t.string "name", :limit => 100
    t.text   "note"
  end

  create_table "companies", :force => true do |t|
    t.string   "name",       :limit => 100
    t.string   "phone",      :limit => 20
    t.string   "address",    :limit => 200
    t.integer  "zone_id"
    t.string   "email",      :limit => 50
    t.string   "website",    :limit => 100
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "customers", :force => true do |t|
    t.string   "name",        :limit => 100
    t.string   "address",     :limit => 100
    t.datetime "birthday"
    t.string   "mobile",      :limit => 20
    t.string   "email",       :limit => 50
    t.integer  "status_id",                  :default => 1
    t.integer  "zone_id"
    t.integer  "company_id"
    t.integer  "district_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "phone",       :limit => 50
  end

  create_table "dish_dates", :force => true do |t|
    t.date    "date"
    t.integer "dish_id"
    t.integer "quantity", :default => 0
  end

  create_table "dishes", :force => true do |t|
    t.string   "name",        :limit => 100
    t.integer  "price",                      :default => 0
    t.integer  "category_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "districts", :force => true do |t|
    t.string "name", :limit => 50
  end

  create_table "employees", :force => true do |t|
    t.string   "name",       :limit => 50
    t.string   "phone",      :limit => 20
    t.string   "address",    :limit => 200
    t.string   "cmnd",       :limit => 10
    t.datetime "start_date"
    t.datetime "end_date"
    t.datetime "birthday"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "menu_dates", :force => true do |t|
    t.date    "date"
    t.integer "menu_id"
  end

  create_table "menu_dishes", :force => true do |t|
    t.integer "menu_id"
    t.integer "dish_id"
    t.integer "quantity", :default => 0
  end

  create_table "menus", :force => true do |t|
    t.string   "name",        :limit => 50
    t.integer  "combo_price"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "order_dishes", :force => true do |t|
    t.integer "order_id"
    t.integer "dish_id"
    t.integer "quantity", :default => 0
  end

  create_table "orders", :force => true do |t|
    t.date     "delivery_date"
    t.text     "note"
    t.integer  "customer_id"
    t.integer  "employee_id"
    t.integer  "total_price",                 :default => 0
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "delivery_time", :limit => 10, :default => "11:30"
    t.integer  "discount",                    :default => 0
    t.string   "status",        :limit => 6,  :default => "new"
    t.text     "delivery_note"
    t.string   "code",          :limit => 20
  end

  create_table "users", :force => true do |t|
    t.string   "login"
    t.string   "email"
    t.string   "crypted_password",          :limit => 40
    t.string   "salt",                      :limit => 40
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "remember_token"
    t.datetime "remember_token_expires_at"
  end

  create_table "zone_employees", :force => true do |t|
    t.integer "zone_id"
    t.integer "employee_id"
  end

  create_table "zones", :force => true do |t|
    t.string "name", :limit => 50
    t.string "note", :limit => 200
  end

end
