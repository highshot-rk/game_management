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
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20201019152009) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"
  enable_extension "unaccent"

  create_table "active_admin_comments", force: :cascade do |t|
    t.string   "namespace"
    t.text     "body"
    t.string   "resource_id",   null: false
    t.string   "resource_type", null: false
    t.string   "author_type"
    t.integer  "author_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["author_type", "author_id"], name: "index_active_admin_comments_on_author_type_and_author_id", using: :btree
    t.index ["namespace"], name: "index_active_admin_comments_on_namespace", using: :btree
    t.index ["resource_type", "resource_id"], name: "index_active_admin_comments_on_resource_type_and_resource_id", using: :btree
  end

  create_table "activities", force: :cascade do |t|
    t.string   "trackable_type"
    t.integer  "trackable_id"
    t.string   "owner_type"
    t.integer  "owner_id"
    t.string   "key"
    t.text     "parameters"
    t.string   "recipient_type"
    t.integer  "recipient_id"
    t.datetime "created_at",                    null: false
    t.datetime "updated_at",                    null: false
    t.boolean  "unread",         default: true
    t.index ["owner_id", "owner_type"], name: "index_activities_on_owner_id_and_owner_type", using: :btree
    t.index ["recipient_id", "recipient_type"], name: "index_activities_on_recipient_id_and_recipient_type", using: :btree
    t.index ["trackable_id", "trackable_type"], name: "index_activities_on_trackable_id_and_trackable_type", using: :btree
  end

  create_table "auth_codes", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "game_id"
    t.string   "token",      null: false
    t.datetime "expires_at", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["game_id"], name: "index_auth_codes_on_game_id", using: :btree
    t.index ["token"], name: "index_auth_codes_on_token", unique: true, using: :btree
    t.index ["user_id", "game_id"], name: "index_auth_codes_on_user_id_and_game_id", using: :btree
    t.index ["user_id"], name: "index_auth_codes_on_user_id", using: :btree
  end

  create_table "comment_hierarchies", id: false, force: :cascade do |t|
    t.integer "ancestor_id",   null: false
    t.integer "descendant_id", null: false
    t.integer "generations",   null: false
    t.index ["ancestor_id", "descendant_id", "generations"], name: "comment_anc_desc_idx", unique: true, using: :btree
    t.index ["descendant_id"], name: "comment_desc_idx", using: :btree
  end

  create_table "comments", force: :cascade do |t|
    t.integer  "user_id",    null: false
    t.integer  "game_id",    null: false
    t.text     "text",       null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer  "parent_id"
    t.index ["game_id"], name: "index_comments_on_game_id", using: :btree
    t.index ["user_id"], name: "index_comments_on_user_id", using: :btree
  end

  create_table "download_links", force: :cascade do |t|
    t.string   "url"
    t.boolean  "broken",            default: false, null: false
    t.boolean  "play_online",       default: false, null: false
    t.integer  "downloads_count",   default: 0,     null: false
    t.integer  "game_id"
    t.datetime "created_at",                        null: false
    t.datetime "updated_at",                        null: false
    t.string   "file_file_name"
    t.string   "file_content_type"
    t.integer  "file_file_size"
    t.datetime "file_updated_at"
    t.string   "play_online_name"
    t.index ["game_id"], name: "index_download_links_on_game_id", using: :btree
  end

  create_table "downloads", force: :cascade do |t|
    t.integer  "download_link_id",             null: false
    t.integer  "user_id"
    t.integer  "count",            default: 1, null: false
    t.datetime "created_at",                   null: false
    t.string   "ip"
    t.index ["download_link_id", "user_id"], name: "index_downloads_on_download_link_id_and_user_id", unique: true, using: :btree
  end

  create_table "event_languages", force: :cascade do |t|
    t.integer "event_id",    null: false
    t.integer "language_id", null: false
    t.index ["event_id", "language_id"], name: "index_event_languages_on_event_id_and_language_id", unique: true, using: :btree
  end

  create_table "event_subscriptions", force: :cascade do |t|
    t.integer  "user_id",    null: false
    t.integer  "event_id",   null: false
    t.datetime "created_at", null: false
    t.index ["event_id", "user_id"], name: "index_event_subscriptions_on_event_id_and_user_id", unique: true, using: :btree
  end

  create_table "events", force: :cascade do |t|
    t.string   "title",                           null: false
    t.text     "description",                     null: false
    t.text     "rules"
    t.text     "prizes"
    t.text     "website"
    t.integer  "event_type",          default: 0, null: false
    t.datetime "start",                           null: false
    t.datetime "end",                             null: false
    t.integer  "user_id",                         null: false
    t.datetime "created_at",                      null: false
    t.datetime "updated_at",                      null: false
    t.string   "screen_file_name"
    t.string   "screen_content_type"
    t.integer  "screen_file_size"
    t.datetime "screen_updated_at"
    t.string   "slug",                            null: false
    t.index ["slug"], name: "index_events_on_slug", unique: true, using: :btree
    t.index ["user_id"], name: "index_events_on_user_id", using: :btree
  end

  create_table "followings", force: :cascade do |t|
    t.integer  "user_id",    null: false
    t.integer  "game_id",    null: false
    t.datetime "created_at", null: false
    t.index ["game_id", "user_id"], name: "index_followings_on_game_id_and_user_id", unique: true, using: :btree
  end

  create_table "game_languages", force: :cascade do |t|
    t.integer "game_id",     null: false
    t.integer "language_id", null: false
    t.index ["game_id", "language_id"], name: "index_game_languages_on_game_id_and_language_id", unique: true, using: :btree
  end

  create_table "games", force: :cascade do |t|
    t.string   "title",                            null: false
    t.string   "slug",                             null: false
    t.text     "description",                      null: false
    t.integer  "release_type",     default: 0,     null: false
    t.integer  "user_id"
    t.string   "website"
    t.string   "author",                           null: false
    t.integer  "screen_id"
    t.float    "ratings_avg",      default: 0.0,   null: false
    t.float    "ratings_abs",      default: 0.0,   null: false
    t.integer  "ratings_count",    default: 0,     null: false
    t.integer  "screens_count",    default: 0,     null: false
    t.integer  "artworks_count",   default: 0,     null: false
    t.integer  "downloads_count",  default: 0,     null: false
    t.integer  "comments_count",   default: 0,     null: false
    t.integer  "news_count",       default: 0,     null: false
    t.integer  "visits_count",     default: 0,     null: false
    t.integer  "followings_count", default: 0,     null: false
    t.datetime "created_at",                       null: false
    t.datetime "updated_at",                       null: false
    t.integer  "tool_id",                          null: false
    t.integer  "genre_id",                         null: false
    t.boolean  "indiepad",         default: false
    t.string   "token"
    t.text     "long_description"
    t.datetime "last_news_at"
    t.boolean  "adult_content",    default: false
    t.boolean  "mobile_first",     default: false
    t.index ["author"], name: "index_games_on_author", using: :btree
    t.index ["genre_id"], name: "index_games_on_genre_id", using: :btree
    t.index ["screen_id"], name: "index_games_on_screen_id", unique: true, using: :btree
    t.index ["slug"], name: "index_games_on_slug", unique: true, using: :btree
    t.index ["token"], name: "index_games_on_token", unique: true, using: :btree
    t.index ["tool_id"], name: "index_games_on_tool_id", using: :btree
    t.index ["user_id"], name: "index_games_on_user_id", using: :btree
  end

  create_table "genres", force: :cascade do |t|
    t.string   "name",       null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["name"], name: "index_genres_on_name", unique: true, using: :btree
  end

  create_table "homepages", force: :cascade do |t|
    t.boolean  "logo_processing"
    t.datetime "created_at",        null: false
    t.datetime "updated_at",        null: false
    t.string   "logo_file_name"
    t.string   "logo_content_type"
    t.integer  "logo_file_size"
    t.datetime "logo_updated_at"
    t.string   "logo_description"
  end

  create_table "indiepad_configs", force: :cascade do |t|
    t.json    "data",    null: false
    t.integer "game_id", null: false
    t.index ["game_id"], name: "index_indiepad_configs_on_game_id", unique: true, using: :btree
  end

  create_table "languages", force: :cascade do |t|
    t.string   "name",       null: false
    t.string   "locale",     null: false
    t.datetime "created_at", null: false
    t.index ["locale"], name: "index_languages_on_locale", unique: true, using: :btree
    t.index ["name"], name: "index_languages_on_name", unique: true, using: :btree
  end

  create_table "medals", force: :cascade do |t|
    t.string   "key"
    t.integer  "score"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "game_id"
    t.integer  "user_id"
    t.boolean  "descending", default: false, null: false
    t.text     "story",      default: [],    null: false, array: true
    t.index ["game_id"], name: "index_medals_on_game_id", using: :btree
    t.index ["key", "game_id", "user_id"], name: "index_medals_on_key_and_game_id_and_user_id", unique: true, using: :btree
    t.index ["key"], name: "index_medals_on_key", using: :btree
    t.index ["user_id"], name: "index_medals_on_user_id", using: :btree
  end

  create_table "monetisations", force: :cascade do |t|
    t.integer  "game_id"
    t.string   "paypal_account"
    t.boolean  "approved",                    default: false
    t.string   "description"
    t.datetime "created_at",                                  null: false
    t.datetime "updated_at",                                  null: false
    t.string   "prize_one_file_file_name"
    t.string   "prize_one_file_content_type"
    t.integer  "prize_one_file_file_size"
    t.datetime "prize_one_file_updated_at"
    t.string   "prize_two_file_file_name"
    t.string   "prize_two_file_content_type"
    t.integer  "prize_two_file_file_size"
    t.datetime "prize_two_file_updated_at"
    t.index ["game_id"], name: "index_monetisations_on_game_id", using: :btree
  end

  create_table "news", force: :cascade do |t|
    t.text     "text",       null: false
    t.integer  "game_id",    null: false
    t.integer  "user_id",    null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["game_id"], name: "index_news_on_game_id", using: :btree
    t.index ["user_id"], name: "index_news_on_user_id", using: :btree
  end

  create_table "platform_links", force: :cascade do |t|
    t.integer "download_link_id", null: false
    t.integer "platform_id",      null: false
    t.index ["download_link_id", "platform_id"], name: "index_platform_links_on_download_link_id_and_platform_id", unique: true, using: :btree
    t.index ["download_link_id"], name: "index_platform_links_on_download_link_id", using: :btree
    t.index ["platform_id"], name: "index_platform_links_on_platform_id", using: :btree
  end

  create_table "platforms", force: :cascade do |t|
    t.string   "name",       null: false
    t.datetime "created_at", null: false
    t.string   "slug",       null: false
    t.index ["name"], name: "index_platforms_on_name", unique: true, using: :btree
    t.index ["slug"], name: "index_platforms_on_slug", unique: true, using: :btree
  end

  create_table "ratings", force: :cascade do |t|
    t.integer  "user_id",                  null: false
    t.integer  "game_id",                  null: false
    t.float    "rating",     default: 0.0, null: false
    t.datetime "created_at",               null: false
    t.datetime "updated_at",               null: false
    t.index ["game_id"], name: "index_ratings_on_game_id", using: :btree
    t.index ["user_id", "game_id"], name: "index_ratings_on_user_id_and_game_id", unique: true, using: :btree
    t.index ["user_id"], name: "index_ratings_on_user_id", using: :btree
  end

  create_table "reports", force: :cascade do |t|
    t.integer  "user_id",                          null: false
    t.integer  "download_link_id",                 null: false
    t.integer  "reason",           default: 0,     null: false
    t.text     "message"
    t.boolean  "resolved",         default: false, null: false
    t.datetime "created_at",                       null: false
    t.datetime "updated_at",                       null: false
    t.index ["download_link_id"], name: "index_reports_on_download_link_id", using: :btree
    t.index ["user_id"], name: "index_reports_on_user_id", using: :btree
  end

  create_table "resources", force: :cascade do |t|
    t.string   "type",              null: false
    t.text     "url"
    t.integer  "game_id"
    t.datetime "created_at",        null: false
    t.datetime "updated_at",        null: false
    t.string   "file_file_name"
    t.string   "file_content_type"
    t.integer  "file_file_size"
    t.datetime "file_updated_at"
    t.boolean  "file_processing"
    t.index ["game_id"], name: "index_resources_on_game_id", using: :btree
  end

  create_table "scores", force: :cascade do |t|
    t.integer  "game_id",                null: false
    t.integer  "user_id",                null: false
    t.string   "name"
    t.integer  "value",      default: 0, null: false
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
    t.index ["game_id"], name: "index_scores_on_game_id", using: :btree
    t.index ["user_id", "game_id", "name"], name: "index_scores_on_user_id_and_game_id_and_name", unique: true, using: :btree
    t.index ["user_id"], name: "index_scores_on_user_id", using: :btree
    t.index ["value"], name: "index_scores_on_value", using: :btree
  end

  create_table "settings", force: :cascade do |t|
    t.integer "user_id",                            null: false
    t.json    "data"
    t.integer "language"
    t.boolean "notification_sound", default: true
    t.boolean "adult_content",      default: false
    t.index ["user_id"], name: "index_settings_on_user_id", unique: true, using: :btree
  end

  create_table "sitemap_fragments", force: :cascade do |t|
    t.text     "content",           null: false
    t.integer  "fragmentable_id",   null: false
    t.string   "fragmentable_type", null: false
    t.datetime "created_at",        null: false
    t.datetime "updated_at",        null: false
    t.index ["fragmentable_id", "fragmentable_type"], name: "sitemap_fragmentable", unique: true, using: :btree
  end

  create_table "slideshows", force: :cascade do |t|
    t.text     "url",                null: false
    t.datetime "created_at",         null: false
    t.datetime "updated_at",         null: false
    t.string   "image_file_name"
    t.string   "image_content_type"
    t.integer  "image_file_size"
    t.datetime "image_updated_at"
    t.boolean  "image_processing"
  end

  create_table "stats", force: :cascade do |t|
    t.integer "game_id",                null: false
    t.integer "downloads",  default: 0, null: false
    t.integer "visits",     default: 0, null: false
    t.date    "created_at",             null: false
    t.index ["game_id", "created_at"], name: "index_stats_on_game_id_and_created_at", unique: true, using: :btree
  end

  create_table "supporters", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "game_id"
    t.integer  "prize"
    t.boolean  "confirmed",  default: false
    t.datetime "created_at",                 null: false
    t.datetime "updated_at",                 null: false
    t.index ["game_id"], name: "index_supporters_on_game_id", using: :btree
    t.index ["user_id"], name: "index_supporters_on_user_id", using: :btree
  end

  create_table "tools", force: :cascade do |t|
    t.string   "name",       null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["name"], name: "index_tools_on_name", unique: true, using: :btree
  end

  create_table "users", force: :cascade do |t|
    t.string   "username",                               null: false
    t.string   "email",                  default: "",    null: false
    t.string   "encrypted_password",     default: "",    null: false
    t.string   "legacy_password"
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,     null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.string   "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string   "unconfirmed_email"
    t.boolean  "staff",                  default: false, null: false
    t.integer  "notifications_count",    default: 0,     null: false
    t.integer  "score",                  default: 0,     null: false
    t.datetime "created_at",                             null: false
    t.datetime "updated_at",                             null: false
    t.string   "token"
    t.boolean  "verified",               default: false
    t.datetime "banned_at"
    t.string   "first_name"
    t.string   "surname"
    t.string   "phone_number"
    t.index ["confirmation_token"], name: "index_users_on_confirmation_token", unique: true, using: :btree
    t.index ["email"], name: "index_users_on_email", unique: true, using: :btree
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree
    t.index ["token"], name: "index_users_on_token", unique: true, using: :btree
    t.index ["username"], name: "index_users_on_username", unique: true, using: :btree
  end

  create_table "visits", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "game_id"
    t.integer  "count",      default: 1, null: false
    t.datetime "created_at",             null: false
    t.index ["game_id"], name: "index_visits_on_game_id", using: :btree
    t.index ["user_id"], name: "index_visits_on_user_id", using: :btree
  end

  add_foreign_key "auth_codes", "games"
  add_foreign_key "auth_codes", "users"
  add_foreign_key "comments", "games"
  add_foreign_key "comments", "users"
  add_foreign_key "download_links", "games"
  add_foreign_key "downloads", "download_links"
  add_foreign_key "downloads", "users"
  add_foreign_key "event_languages", "events"
  add_foreign_key "event_languages", "languages"
  add_foreign_key "event_subscriptions", "events"
  add_foreign_key "event_subscriptions", "users"
  add_foreign_key "followings", "games"
  add_foreign_key "followings", "users"
  add_foreign_key "game_languages", "games"
  add_foreign_key "game_languages", "languages"
  add_foreign_key "games", "genres"
  add_foreign_key "games", "tools"
  add_foreign_key "games", "users"
  add_foreign_key "indiepad_configs", "games"
  add_foreign_key "monetisations", "games"
  add_foreign_key "news", "games"
  add_foreign_key "news", "users"
  add_foreign_key "platform_links", "download_links"
  add_foreign_key "platform_links", "platforms"
  add_foreign_key "ratings", "games"
  add_foreign_key "ratings", "users"
  add_foreign_key "reports", "download_links"
  add_foreign_key "reports", "users"
  add_foreign_key "resources", "games"
  add_foreign_key "scores", "games"
  add_foreign_key "scores", "users"
  add_foreign_key "settings", "users"
  add_foreign_key "stats", "games"
  add_foreign_key "supporters", "games"
  add_foreign_key "supporters", "users"
end
