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

ActiveRecord::Schema.define(:version => 20150911200840) do

  create_table "categories", :force => true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "name"
  end

  create_table "categories_events", :id => false, :force => true do |t|
    t.integer "category_id"
    t.integer "event_id"
  end

  create_table "category_preference_categories", :force => true do |t|
    t.integer  "category_preference_id"
    t.integer  "category_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "category_preferences", :force => true do |t|
    t.string   "name"
    t.text     "description"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "user_id"
  end

  create_table "events", :force => true do |t|
    t.string   "name",                               :null => false
    t.text     "description",                        :null => false
    t.string   "location",                           :null => false
    t.datetime "event_start"
    t.datetime "event_end"
    t.integer  "pattern"
    t.integer  "approval_rating", :default => 100
    t.string   "approver_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "summary"
    t.boolean  "cancelled",       :default => false
    t.integer  "organization_id"
    t.integer  "user_id"
    t.string   "url"
    t.string   "flyer_url"
  end

  create_table "organization_users", :id => false, :force => true do |t|
    t.integer  "organization_id"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "organizations", :force => true do |t|
    t.string   "name",       :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "url"
  end

  create_table "users", :force => true do |t|
    t.string   "first_name",                       :null => false
    t.string   "last_name",                        :null => false
    t.string   "andrew_id",                        :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "is_admin",      :default => false
    t.boolean  "is_org_leader", :default => false
    t.boolean  "is_developer",  :default => false
  end

end
