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

ActiveRecord::Schema.define(:version => 20110222162549) do

  create_table "authorized_url_infosell_resources", :force => true do |t|
    t.integer  "authorized_url_id"
    t.string   "elementary_resource_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "authorized_url_infosell_resources", ["authorized_url_id", "elementary_resource_id"], :name => "relation_index"

  create_table "roles", :force => true do |t|
    t.string   "name",       :default => "", :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "roles", ["name"], :name => "index_services.roles_on_name", :unique => true

  create_table "roles_users", :id => false, :force => true do |t|
    t.integer "role_id", :null => false
    t.integer "user_id", :null => false
  end

  create_table "user_infosell_requisites", :force => true do |t|
    t.integer  "user_id"
    t.string   "infosell_code"
    t.boolean  "is_current"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "user_infosell_requisites", ["user_id"], :name => "index_services.user_infosell_requisites_on_user_id"

end
