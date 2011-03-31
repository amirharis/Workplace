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

ActiveRecord::Schema.define(:version => 20110331051520) do

  create_table "longurls", :force => true do |t|
    t.string   "url"
    t.string   "sha1"
    t.integer  "count"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "longurls", ["sha1"], :name => "index_longurls_on_sha1", :unique => true
  add_index "longurls", ["url"], :name => "index_longurls_on_url", :unique => true

  create_table "shorturl_histories", :force => true do |t|
    t.string   "shorturl_id"
    t.string   "remote_addr"
    t.string   "user_agent"
    t.string   "remote_host"
    t.string   "browser"
    t.string   "os"
    t.string   "referer"
    t.string   "country"
    t.string   "state"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "shorturl_histories", ["browser"], :name => "index_shorturl_histories_on_browser"
  add_index "shorturl_histories", ["country"], :name => "index_shorturl_histories_on_country"
  add_index "shorturl_histories", ["created_at"], :name => "index_shorturl_histories_on_created_at"
  add_index "shorturl_histories", ["os"], :name => "index_shorturl_histories_on_os"

  create_table "shorturls", :force => true do |t|
    t.integer  "user_id"
    t.integer  "longurl_id"
    t.string   "host_data"
    t.string   "shortcode"
    t.integer  "hits"
    t.string   "status"
    t.string   "short_url"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "shorturls", ["short_url"], :name => "index_shorturls_on_short_url", :unique => true

  create_table "urlhashes", :force => true do |t|
    t.string   "shorturl_id"
    t.string   "sha1"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "urlhashes", ["sha1"], :name => "index_urlhashes_on_sha1", :unique => true

  create_table "users", :force => true do |t|
    t.string   "email"
    t.string   "uid"
    t.string   "first_name"
    t.string   "last_name"
    t.string   "nickname"
    t.string   "link"
    t.string   "gender"
    t.string   "timezone"
    t.string   "locale"
    t.boolean  "verified"
    t.string   "updated_time"
    t.string   "token"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "users", ["email"], :name => "index_users_on_email", :unique => true

end
