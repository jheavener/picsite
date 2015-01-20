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

ActiveRecord::Schema.define(:version => 20150102020122) do

  create_table "users", :force => true do |t|
    t.string   "username",              :limit => 30,                        :null => false
    t.string   "status",                :limit => 10,  :default => "active", :null => false
    t.string   "display_name",          :limit => 30,                        :null => false
    t.string   "email",                 :limit => 100
    t.string   "password_digest",                                            :null => false
    t.string   "forgot_password_token", :limit => 60
    t.datetime "forgot_password_at"
    t.datetime "created_at",                                                 :null => false
    t.datetime "updated_at",                                                 :null => false
  end

  add_index "users", ["forgot_password_token"], :name => "index_users_on_forgot_password_token", :unique => true
  add_index "users", ["status", "username"], :name => "index_users_on_status_and_username"
  add_index "users", ["username"], :name => "index_users_on_username", :unique => true

end
