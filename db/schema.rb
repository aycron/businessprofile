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

ActiveRecord::Schema.define(:version => 20100914185415) do

  create_table "ga_configs", :force => true do |t|
    t.string  "event"
    t.integer "value"
    t.text    "description"
  end

  create_table "gallery_images", :force => true do |t|
    t.integer  "position"
    t.integer  "profile_id"
    t.string   "image_file_name"
    t.string   "image_content_type"
    t.integer  "image_file_size"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "markers", :force => true do |t|
    t.integer "profile_id"
    t.decimal "lat",        :precision => 15, :scale => 10
    t.decimal "lng",        :precision => 15, :scale => 10
  end

  create_table "options", :force => true do |t|
    t.string   "key",                         :default => "", :null => false
    t.string   "value",       :limit => 8000
    t.string   "option_type", :limit => 20
    t.text     "description"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "pages", :force => true do |t|
    t.string   "name",               :default => "", :null => false
    t.string   "title"
    t.text     "content"
    t.integer  "position"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "meta_description"
    t.string   "meta_keywords"
    t.string   "meta_verify_v1"
    t.string   "photo_file_name"
    t.string   "photo_content_type"
    t.integer  "photo_file_size"
    t.datetime "photo_updated_at"
  end

  create_table "profile_tabs", :force => true do |t|
    t.integer  "profile_id"
    t.integer  "position"
    t.string   "name"
    t.string   "tab_type"
    t.string   "video_url"
    t.text     "content"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "profiles", :force => true do |t|
    t.string   "title",                :default => "", :null => false
    t.string   "short_description"
    t.text     "description"
    t.text     "address"
    t.text     "phones"
    t.string   "url"
    t.string   "website"
    t.string   "facebook_url"
    t.string   "contact_email"
    t.string   "mail_subject"
    t.text     "mail_body"
    t.string   "logo_file_name"
    t.string   "logo_content_type"
    t.integer  "logo_file_size"
    t.string   "image_file_name"
    t.string   "image_content_type"
    t.integer  "image_file_size"
    t.string   "gallery_title"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "gallery_label"
    t.string   "second_contact_email"
    t.string   "meta_description"
    t.string   "meta_keywords"
    t.string   "meta_verify_v1"
    t.string   "contact_me_subject"
    t.boolean  "active"
    t.string   "site_link_name"
    t.string   "google_analytics"
  end

  create_table "role_controllers", :force => true do |t|
    t.integer  "role_id",                       :null => false
    t.string   "controller", :default => "",    :null => false
    t.boolean  "can_view",   :default => false, :null => false
    t.boolean  "can_edit",   :default => false, :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "role_controllers", ["role_id", "controller"], :name => "index_role_controllers_on_role_id_and_controller"

  create_table "roles", :force => true do |t|
    t.string   "name",           :default => "",    :null => false
    t.boolean  "is_super_admin", :default => false, :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "users", :force => true do |t|
    t.string   "username",            :default => "", :null => false
    t.string   "first_name"
    t.string   "last_name"
    t.string   "hashed_password",     :default => "", :null => false
    t.integer  "role_id"
    t.string   "email",               :default => "", :null => false
    t.string   "password_reset_code"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "profile_id"
  end

  add_index "users", ["email"], :name => "index_users_on_email"
  add_index "users", ["username"], :name => "index_users_on_username"

end
