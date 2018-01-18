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

ActiveRecord::Schema.define(version: 20180118142427) do

  create_table "accounts", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string "username"
    t.string "slug"
    t.string "domain"
    t.string "status"
    t.string "sign_up_mode"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "logo_image_id"
    t.index ["domain"], name: "index_accounts_on_domain"
    t.index ["slug"], name: "index_accounts_on_slug", unique: true
    t.index ["username"], name: "index_accounts_on_username", unique: true
  end

  create_table "activities", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.integer "user_id"
    t.string "action"
    t.integer "trackable_id"
    t.string "trackable_type"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "folder_id"
    t.integer "account_id"
    t.integer "site_id"
  end

  create_table "audio_variations", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.integer "audio_id"
    t.integer "start_time"
    t.integer "end_time"
    t.boolean "is_original"
    t.integer "total_time"
    t.string "subtitle_file_path"
    t.integer "created_by"
    t.integer "updated_by"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.text "audio_key"
    t.index ["audio_id"], name: "index_audio_variations_on_audio_id"
    t.index ["id"], name: "index_audio_variations_on_id", unique: true
  end

  create_table "audios", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.integer "account_id"
    t.string "name"
    t.string "audio"
    t.text "description"
    t.string "s3_identifier"
    t.integer "total_time"
    t.integer "created_by"
    t.integer "updated_by"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["account_id"], name: "index_audios_on_account_id"
    t.index ["id"], name: "index_audios_on_id", unique: true
    t.index ["s3_identifier"], name: "index_audios_on_s3_identifier", unique: true
  end

  create_table "authentications", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string "provider"
    t.string "uid"
    t.text "info"
    t.string "name"
    t.string "email"
    t.string "access_token"
    t.string "access_token_secret"
    t.string "refresh_token"
    t.datetime "token_expires_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "user_id"
    t.integer "site_id"
    t.index ["user_id"], name: "index_authentications_on_user_id"
  end

  create_table "colour_swatches", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.integer "red"
    t.integer "green"
    t.integer "blue"
    t.integer "image_id"
    t.boolean "is_dominant", default: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "name"
  end

  create_table "folders", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.integer "account_id"
    t.string "name"
    t.string "slug"
    t.integer "created_by"
    t.integer "updated_by"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "is_trash", default: false
    t.boolean "is_archived", default: false
    t.integer "site_id"
  end

  create_table "friendly_id_slugs", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string "slug", null: false
    t.integer "sluggable_id", null: false
    t.string "sluggable_type", limit: 50
    t.string "scope"
    t.datetime "created_at"
    t.index ["slug", "sluggable_type", "scope"], name: "index_friendly_id_slugs_on_slug_and_sluggable_type_and_scope", unique: true
    t.index ["slug", "sluggable_type"], name: "index_friendly_id_slugs_on_slug_and_sluggable_type"
    t.index ["sluggable_id"], name: "index_friendly_id_slugs_on_sluggable_id"
    t.index ["sluggable_type"], name: "index_friendly_id_slugs_on_sluggable_type"
  end

  create_table "image_variations", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.integer "image_id"
    t.text "image_key"
    t.integer "image_width"
    t.integer "image_height"
    t.text "thumbnail_url"
    t.text "thumbnail_key"
    t.integer "thumbnail_width"
    t.integer "thumbnail_height"
    t.boolean "is_original"
    t.integer "created_by"
    t.integer "updated_by"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "mode"
    t.boolean "is_social_image"
    t.boolean "is_smart_cropped", default: false
  end

  create_table "images", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.integer "account_id"
    t.string "name"
    t.text "description"
    t.string "s3_identifier"
    t.text "thumbnail_url"
    t.text "thumbnail_key"
    t.integer "thumbnail_width"
    t.integer "thumbnail_height"
    t.integer "image_width"
    t.integer "image_height"
    t.string "image"
    t.integer "created_by"
    t.integer "updated_by"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "is_logo", default: false
  end

  create_table "page_streams", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.integer "page_id"
    t.integer "stream_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "pages", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.integer "site_id"
    t.integer "account_id"
    t.string "folder_id"
    t.string "headline"
    t.text "meta_description"
    t.datetime "publised_date"
    t.boolean "is_published"
    t.text "summary"
    t.string "alignment"
    t.boolean "isinteractive"
    t.string "genre"
    t.string "sub_genre"
    t.string "series"
    t.string "by_line"
    t.integer "cover_image_id"
    t.integer "created_by"
    t.integer "updated_by"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "permission_invites", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.integer "account_id"
    t.string "email"
    t.string "ref_role_slug"
    t.integer "created_by"
    t.integer "updated_by"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "permissions", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.integer "user_id"
    t.integer "account_id"
    t.string "ref_role_slug"
    t.string "status"
    t.integer "created_by"
    t.integer "updated_by"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "is_hidden", default: false
  end

  create_table "ref_categories", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.integer "site_id"
    t.string "category"
    t.string "name"
    t.text "stream_url"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "stream_id"
    t.boolean "is_disabled"
    t.integer "created_by"
    t.integer "updated_by"
  end

  create_table "ref_link_sources", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string "name"
    t.text "url"
    t.text "favicon_url"
    t.integer "created_by"
    t.integer "updated_by"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "ref_tags", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.integer "site_id"
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "site_view_casts", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.integer "site_id"
    t.integer "view_cast_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "sites", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.integer "account_id"
    t.string "name"
    t.string "domain"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.text "description"
    t.string "primary_language"
    t.text "default_seo_keywords"
    t.string "house_colour"
    t.string "reverse_house_colour"
    t.string "font_colour"
    t.string "reverse_font_colour"
    t.text "stream_url"
    t.integer "stream_id"
    t.string "cdn_provider"
    t.string "cdn_id"
    t.text "host"
    t.text "cdn_endpoint"
    t.string "client_token"
    t.string "access_token"
    t.string "client_secret"
    t.text "facebook_url"
    t.text "twitter_url"
    t.text "instagram_url"
    t.text "youtube_url"
  end

  create_table "stream_entities", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.integer "stream_id"
    t.string "entity_type"
    t.string "entity_value"
    t.boolean "is_excluded"
    t.integer "created_by"
    t.integer "updated_by"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "streams", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string "title"
    t.string "slug"
    t.text "description"
    t.integer "folder_id"
    t.integer "account_id"
    t.string "datacast_identifier"
    t.integer "created_by"
    t.integer "updated_by"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "card_count"
    t.datetime "last_published_at"
    t.string "order_by_key"
    t.string "order_by_value"
    t.integer "limit"
    t.integer "offset"
    t.boolean "is_grouped_data_stream", default: false
    t.string "data_group_key"
    t.text "filter_query"
    t.string "data_group_value"
    t.integer "site_id"
    t.boolean "include_data", default: false
    t.boolean "is_automated_stream", default: false
    t.string "col_name"
    t.integer "col_id"
    t.string "order_by_type"
    t.index ["description"], name: "index_streams_on_description", type: :fulltext
    t.index ["title"], name: "index_streams_on_title", type: :fulltext
  end

  create_table "taggings", id: :integer, force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.integer "tag_id"
    t.string "taggable_type"
    t.integer "taggable_id"
    t.string "tagger_type"
    t.integer "tagger_id"
    t.string "context", limit: 128
    t.datetime "created_at"
    t.index ["context"], name: "index_taggings_on_context"
    t.index ["tag_id", "taggable_id", "taggable_type", "context", "tagger_id", "tagger_type"], name: "taggings_idx", unique: true
    t.index ["tag_id"], name: "index_taggings_on_tag_id"
    t.index ["taggable_id", "taggable_type", "context"], name: "index_taggings_on_taggable_id_and_taggable_type_and_context"
    t.index ["taggable_id", "taggable_type", "tagger_id", "context"], name: "taggings_idy"
    t.index ["taggable_id"], name: "index_taggings_on_taggable_id"
    t.index ["taggable_type"], name: "index_taggings_on_taggable_type"
    t.index ["tagger_id", "tagger_type"], name: "index_taggings_on_tagger_id_and_tagger_type"
    t.index ["tagger_id"], name: "index_taggings_on_tagger_id"
  end

  create_table "template_cards", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.integer "account_id"
    t.string "name"
    t.string "elevator_pitch"
    t.text "description"
    t.string "global_slug"
    t.boolean "is_current_version"
    t.string "slug"
    t.string "version_series"
    t.integer "previous_version_id"
    t.string "version_genre"
    t.string "version"
    t.text "change_log"
    t.string "status"
    t.integer "publish_count"
    t.boolean "is_public"
    t.text "git_url"
    t.string "git_branch", default: "master"
    t.integer "created_by"
    t.integer "updated_by"
    t.integer "template_datum_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "has_static_image", default: false
    t.string "git_repo_name"
    t.string "s3_identifier"
    t.boolean "has_multiple_uploads", default: false
    t.boolean "has_grouping", default: false
    t.text "allowed_views"
    t.index ["slug"], name: "index_template_cards_on_slug", unique: true
  end

  create_table "template_data", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string "name"
    t.string "global_slug"
    t.string "slug"
    t.string "version"
    t.text "change_log"
    t.integer "publish_count"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "s3_identifier"
    t.string "status"
    t.index ["slug"], name: "index_template_data_on_slug", unique: true
  end

  create_table "uploads", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string "attachment"
    t.bigint "template_card_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "account_id"
    t.bigint "folder_id"
    t.integer "created_by"
    t.integer "updated_by"
    t.text "upload_errors"
    t.text "filtering_errors"
    t.string "upload_status", default: "waiting"
    t.integer "total_rows"
    t.integer "rows_uploaded"
    t.index ["account_id"], name: "index_uploads_on_account_id"
    t.index ["folder_id"], name: "index_uploads_on_folder_id"
    t.index ["template_card_id"], name: "index_uploads_on_template_card_id"
  end

  create_table "user_emails", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.bigint "user_id"
    t.string "email"
    t.string "confirmation_token"
    t.datetime "confirmation_sent_at"
    t.datetime "confirmed_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "is_primary_email"
    t.index ["user_id"], name: "index_user_emails_on_user_id"
  end

  create_table "users", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string "name", default: "", null: false
    t.string "email", default: "", null: false
    t.string "access_token"
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer "sign_in_count", default: 0, null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string "current_sign_in_ip"
    t.string "last_sign_in_ip"
    t.string "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string "unconfirmed_email"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "can_publish_link_sources", default: false
    t.index ["confirmation_token"], name: "index_users_on_confirmation_token", unique: true
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  create_table "view_casts", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.integer "account_id"
    t.string "datacast_identifier"
    t.integer "template_card_id"
    t.integer "template_datum_id"
    t.string "name"
    t.text "optionalConfigJSON"
    t.string "slug"
    t.integer "created_by"
    t.integer "updated_by"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.text "seo_blockquote"
    t.text "render_screenshot_key"
    t.text "status"
    t.integer "folder_id"
    t.boolean "is_invalidating"
    t.string "default_view"
    t.string "genre"
    t.string "sub_genre"
    t.string "series"
    t.string "by_line"
    t.index ["slug"], name: "index_view_casts_on_slug", unique: true
  end

  add_foreign_key "uploads", "accounts"
  add_foreign_key "uploads", "folders"
  add_foreign_key "uploads", "template_cards"
  add_foreign_key "user_emails", "users"
end
