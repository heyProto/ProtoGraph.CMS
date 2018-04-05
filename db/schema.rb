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

ActiveRecord::Schema.define(version: 20180405155521) do

  create_table "accounts", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4" do |t|
    t.string "username", limit: 191, collation: "utf8mb4_unicode_ci"
    t.string "slug", limit: 191, collation: "utf8mb4_unicode_ci"
    t.string "status", collation: "utf8mb4_unicode_ci"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "cdn_provider", collation: "utf8mb4_unicode_ci"
    t.string "cdn_id", collation: "utf8mb4_unicode_ci"
    t.text "host", collation: "utf8mb4_unicode_ci"
    t.text "cdn_endpoint", collation: "utf8mb4_unicode_ci"
    t.string "client_token", collation: "utf8mb4_unicode_ci"
    t.string "access_token", collation: "utf8mb4_unicode_ci"
    t.string "client_secret", collation: "utf8mb4_unicode_ci"
    t.index ["slug"], name: "index_accounts_on_slug", unique: true
    t.index ["username"], name: "index_accounts_on_username", unique: true
  end

  create_table "activities", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4" do |t|
    t.integer "user_id"
    t.string "action", collation: "utf8mb4_unicode_ci"
    t.integer "trackable_id"
    t.string "trackable_type", collation: "utf8mb4_unicode_ci"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "folder_id"
    t.integer "account_id"
    t.integer "site_id"
    t.integer "created_by"
    t.integer "updated_by"
  end

  create_table "audio_variations", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4" do |t|
    t.integer "audio_id"
    t.integer "start_time"
    t.integer "end_time"
    t.boolean "is_original"
    t.integer "total_time"
    t.string "subtitle_file_path", collation: "utf8_general_ci"
    t.integer "created_by"
    t.integer "updated_by"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.text "audio_key", collation: "utf8_general_ci"
    t.integer "account_id"
    t.index ["audio_id"], name: "index_audio_variations_on_audio_id"
    t.index ["id"], name: "index_audio_variations_on_id", unique: true
  end

  create_table "audios", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4" do |t|
    t.integer "account_id"
    t.string "name", collation: "utf8_general_ci"
    t.string "audio", collation: "utf8_general_ci"
    t.text "description", collation: "utf8_general_ci"
    t.string "s3_identifier", collation: "utf8_general_ci"
    t.integer "total_time"
    t.integer "created_by"
    t.integer "updated_by"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["account_id"], name: "index_audios_on_account_id"
    t.index ["id"], name: "index_audios_on_id", unique: true
    t.index ["s3_identifier"], name: "index_audios_on_s3_identifier", unique: true
  end

  create_table "authentications", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4" do |t|
    t.string "provider", collation: "utf8_general_ci"
    t.string "uid", collation: "utf8_general_ci"
    t.text "info", collation: "utf8_general_ci"
    t.string "name", collation: "utf8_general_ci"
    t.string "email", collation: "utf8_general_ci"
    t.string "access_token", collation: "utf8_general_ci"
    t.string "access_token_secret", collation: "utf8_general_ci"
    t.string "refresh_token", collation: "utf8_general_ci"
    t.datetime "token_expires_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "user_id"
    t.integer "site_id"
    t.integer "created_by"
    t.integer "updated_by"
    t.integer "account_id"
    t.index ["user_id"], name: "index_authentications_on_user_id"
  end

  create_table "colour_swatches", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4" do |t|
    t.integer "red"
    t.integer "green"
    t.integer "blue"
    t.integer "image_id"
    t.boolean "is_dominant", default: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "name", collation: "utf8_general_ci"
  end

  create_table "folders", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4" do |t|
    t.integer "account_id"
    t.string "name", collation: "utf8_general_ci"
    t.string "slug", collation: "utf8_general_ci"
    t.integer "created_by"
    t.integer "updated_by"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "is_trash", default: false
    t.boolean "is_archived", default: false
    t.integer "site_id"
    t.boolean "is_open"
    t.integer "ref_category_vertical_id"
    t.boolean "is_for_stories"
  end

  create_table "friendly_id_slugs", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4" do |t|
    t.string "slug", null: false, collation: "utf8_general_ci"
    t.integer "sluggable_id", null: false
    t.string "sluggable_type", limit: 50, collation: "utf8_general_ci"
    t.string "scope", collation: "utf8_general_ci"
    t.datetime "created_at"
    t.index ["slug", "sluggable_type", "scope"], name: "index_friendly_id_slugs_on_slug_and_sluggable_type_and_scope", unique: true
    t.index ["slug", "sluggable_type"], name: "index_friendly_id_slugs_on_slug_and_sluggable_type"
    t.index ["sluggable_id"], name: "index_friendly_id_slugs_on_sluggable_id"
    t.index ["sluggable_type"], name: "index_friendly_id_slugs_on_sluggable_type"
  end

  create_table "image_variations", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4" do |t|
    t.integer "image_id"
    t.text "image_key", collation: "utf8_general_ci"
    t.integer "image_width"
    t.integer "image_height"
    t.text "thumbnail_url", collation: "utf8_general_ci"
    t.text "thumbnail_key", collation: "utf8_general_ci"
    t.integer "thumbnail_width"
    t.integer "thumbnail_height"
    t.boolean "is_original"
    t.integer "created_by"
    t.integer "updated_by"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "mode", collation: "utf8_general_ci"
    t.boolean "is_social_image"
    t.boolean "is_smart_cropped", default: false
    t.integer "account_id"
  end

  create_table "images", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4" do |t|
    t.integer "account_id"
    t.string "name", collation: "utf8_general_ci"
    t.text "description", collation: "utf8_general_ci"
    t.string "s3_identifier", collation: "utf8_general_ci"
    t.text "thumbnail_url", collation: "utf8_general_ci"
    t.text "thumbnail_key", collation: "utf8_general_ci"
    t.integer "thumbnail_width"
    t.integer "thumbnail_height"
    t.integer "image_width"
    t.integer "image_height"
    t.string "image", collation: "utf8_general_ci"
    t.integer "created_by"
    t.integer "updated_by"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "is_logo", default: false
    t.boolean "is_favicon", default: false
    t.boolean "is_cover"
    t.string "credits"
    t.text "credit_link"
  end

  create_table "page_streams", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4" do |t|
    t.integer "page_id"
    t.integer "stream_id"
    t.integer "created_by"
    t.integer "updated_by"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "name_of_stream", collation: "utf8_general_ci"
    t.integer "account_id"
    t.integer "site_id"
    t.integer "folder_id"
  end

  create_table "page_todos", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4" do |t|
    t.integer "page_id"
    t.integer "user_id"
    t.integer "template_card_id"
    t.text "task"
    t.boolean "is_completed"
    t.integer "sort_order"
    t.integer "created_by"
    t.integer "updated_by"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "account_id"
    t.integer "site_id"
    t.integer "folder_id"
  end

  create_table "pages", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4" do |t|
    t.integer "account_id"
    t.integer "site_id"
    t.integer "folder_id"
    t.string "headline", collation: "utf8_general_ci"
    t.string "meta_keywords", collation: "utf8_general_ci"
    t.text "meta_description", collation: "utf8_general_ci"
    t.text "summary", collation: "utf8_general_ci"
    t.text "cover_image_url_facebook", collation: "utf8_general_ci"
    t.text "cover_image_url_square", collation: "utf8_general_ci"
    t.string "cover_image_alignment", collation: "utf8_general_ci"
    t.boolean "is_sponsored"
    t.boolean "is_interactive"
    t.boolean "has_data"
    t.boolean "has_image_other_than_cover"
    t.boolean "has_audio"
    t.boolean "has_video"
    t.datetime "published_at"
    t.text "url", collation: "utf8_general_ci"
    t.integer "ref_category_series_id"
    t.integer "ref_category_intersection_id"
    t.integer "ref_category_sub_intersection_id"
    t.integer "view_cast_id"
    t.text "page_object_url", collation: "utf8_general_ci"
    t.integer "created_by"
    t.integer "updated_by"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "datacast_identifier", collation: "utf8_general_ci"
    t.boolean "is_open"
    t.integer "template_page_id"
    t.string "slug", collation: "utf8_general_ci"
    t.string "english_headline"
    t.string "status"
    t.integer "cover_image_id"
    t.integer "cover_image_id_7_column"
    t.date "due"
    t.text "description"
    t.integer "cover_image_id_4_column"
    t.integer "cover_image_id_3_column"
    t.integer "cover_image_id_2_column"
    t.string "cover_image_credit"
    t.text "share_text_facebook"
    t.text "share_text_twitter"
    t.string "one_line_concept"
    t.text "content"
    t.integer "byline_id"
    t.string "reported_from_country"
    t.string "reported_from_state"
    t.string "reported_from_district"
    t.string "reported_from_city"
  end

  create_table "permission_invites", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4" do |t|
    t.integer "permissible_id"
    t.string "email", collation: "utf8_general_ci"
    t.string "ref_role_slug", collation: "utf8_general_ci"
    t.integer "created_by"
    t.integer "updated_by"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "permissible_type", collation: "utf8_general_ci"
    t.string "name"
    t.boolean "create_user"
    t.boolean "do_not_email_user"
  end

  create_table "permission_roles", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4" do |t|
    t.integer "created_by"
    t.integer "updated_by"
    t.string "name", collation: "utf8_general_ci"
    t.string "slug", collation: "utf8_general_ci"
    t.boolean "can_change_account_settings"
    t.boolean "can_add_image_bank"
    t.boolean "can_see_all_image_bank"
    t.boolean "can_add_site"
    t.boolean "can_change_site_settings"
    t.boolean "can_add_site_people"
    t.boolean "can_add_site_categories"
    t.boolean "can_disable_site_categories"
    t.boolean "can_add_site_tags"
    t.boolean "can_remove_site_tags"
    t.boolean "can_add_folders"
    t.boolean "can_see_all_folders"
    t.boolean "can_add_folder_people"
    t.boolean "can_add_view_casts"
    t.boolean "can_see_all_view_casts"
    t.boolean "can_delete_view_casts"
    t.boolean "can_add_streams"
    t.boolean "can_delete_streams"
    t.boolean "can_see_all_streams"
    t.boolean "can_add_pages"
    t.boolean "can_edit_pages"
    t.boolean "can_see_all_pages"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "permissions", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4" do |t|
    t.integer "user_id"
    t.integer "permissible_id"
    t.string "ref_role_slug", collation: "utf8_general_ci"
    t.string "status", collation: "utf8_general_ci"
    t.integer "created_by"
    t.integer "updated_by"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "is_hidden", default: false
    t.string "permissible_type", collation: "utf8_general_ci"
    t.integer "stream_id"
    t.text "stream_url"
    t.text "bio"
    t.text "meta_description"
    t.string "name"
  end

  create_table "ref_categories", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4" do |t|
    t.integer "site_id"
    t.string "genre", collation: "utf8_general_ci"
    t.string "name", collation: "utf8_general_ci"
    t.text "stream_url", collation: "utf8_general_ci"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "stream_id"
    t.boolean "is_disabled"
    t.integer "created_by"
    t.integer "updated_by"
    t.integer "count", default: 0
    t.string "name_html", collation: "utf8_general_ci"
    t.string "slug"
    t.string "english_name"
    t.text "vertical_page_url"
    t.integer "account_id"
    t.text "description"
    t.text "keywords"
  end

  create_table "ref_link_sources", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4" do |t|
    t.string "name", collation: "utf8_general_ci"
    t.text "url", collation: "utf8_general_ci"
    t.text "favicon_url", collation: "utf8_general_ci"
    t.integer "created_by"
    t.integer "updated_by"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "sessions", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string "session_id", null: false
    t.text "data"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "site_vertical_navigations", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4" do |t|
    t.integer "site_id"
    t.integer "ref_category_vertical_id"
    t.string "name", collation: "utf8_general_ci"
    t.text "url", collation: "utf8_general_ci"
    t.boolean "launch_in_new_window"
    t.integer "created_by"
    t.integer "updated_by"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "sort_order"
    t.integer "account_id"
  end

  create_table "sites", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4" do |t|
    t.integer "account_id"
    t.string "name", collation: "utf8_general_ci"
    t.string "domain", collation: "utf8_general_ci"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.text "description", collation: "utf8_general_ci"
    t.string "primary_language", collation: "utf8_general_ci"
    t.text "default_seo_keywords", collation: "utf8_general_ci"
    t.string "house_colour", collation: "utf8_general_ci"
    t.string "reverse_house_colour", collation: "utf8_general_ci"
    t.string "font_colour", collation: "utf8_general_ci"
    t.string "reverse_font_colour", collation: "utf8_general_ci"
    t.text "stream_url", collation: "utf8_general_ci"
    t.integer "stream_id"
    t.string "cdn_provider", collation: "utf8_general_ci"
    t.string "cdn_id", collation: "utf8_general_ci"
    t.text "host", collation: "utf8_general_ci"
    t.text "cdn_endpoint", collation: "utf8_general_ci"
    t.string "client_token", collation: "utf8_general_ci"
    t.string "access_token", collation: "utf8_general_ci"
    t.string "client_secret", collation: "utf8_general_ci"
    t.integer "favicon_id"
    t.integer "logo_image_id"
    t.text "facebook_url", collation: "utf8_general_ci"
    t.text "twitter_url", collation: "utf8_general_ci"
    t.text "instagram_url", collation: "utf8_general_ci"
    t.text "youtube_url", collation: "utf8_general_ci"
    t.string "g_a_tracking_id", collation: "utf8_general_ci"
    t.string "sign_up_mode", collation: "utf8_general_ci"
    t.string "default_role", collation: "utf8_general_ci"
    t.string "story_card_style", collation: "utf8_general_ci"
    t.string "email_domain", collation: "utf8_general_ci"
    t.string "header_background_color", collation: "utf8_general_ci"
    t.text "header_url", collation: "utf8_general_ci"
    t.string "header_positioning", collation: "utf8_general_ci"
    t.string "slug"
    t.boolean "is_english", default: true
    t.string "english_name"
    t.boolean "story_card_flip", default: false
    t.integer "created_by"
    t.integer "updated_by"
    t.string "seo_name"
    t.boolean "is_lazy_loading_activated", default: true
    t.text "comscore_code"
    t.boolean "is_smart_crop_enabled", default: false
    t.string "gtm_id"
  end

  create_table "stream_entities", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4" do |t|
    t.integer "stream_id"
    t.string "entity_type", collation: "utf8_general_ci"
    t.string "entity_value", collation: "utf8_general_ci"
    t.boolean "is_excluded"
    t.integer "created_by"
    t.integer "updated_by"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "sort_order"
  end

  create_table "streams", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4" do |t|
    t.string "title", collation: "utf8_general_ci"
    t.string "slug", collation: "utf8_general_ci"
    t.text "description", collation: "utf8_general_ci"
    t.integer "folder_id"
    t.integer "account_id"
    t.string "datacast_identifier", collation: "utf8_general_ci"
    t.integer "created_by"
    t.integer "updated_by"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "card_count"
    t.datetime "last_published_at"
    t.string "order_by_key", collation: "utf8_general_ci"
    t.string "order_by_value", collation: "utf8_general_ci"
    t.integer "limit"
    t.integer "offset"
    t.boolean "is_grouped_data_stream", default: false
    t.string "data_group_key", collation: "utf8_general_ci"
    t.text "filter_query", collation: "utf8_general_ci"
    t.string "data_group_value", collation: "utf8_general_ci"
    t.integer "site_id"
    t.boolean "include_data", default: false
    t.boolean "is_automated_stream", default: false
    t.string "col_name", collation: "utf8_general_ci"
    t.integer "col_id"
    t.string "order_by_type", collation: "utf8_general_ci"
    t.boolean "is_open"
    t.index ["description"], name: "index_streams_on_description", type: :fulltext
    t.index ["title"], name: "index_streams_on_title", type: :fulltext
  end

  create_table "taggings", id: :integer, force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4" do |t|
    t.integer "tag_id"
    t.string "taggable_type", collation: "utf8_general_ci"
    t.integer "taggable_id"
    t.string "tagger_type", collation: "utf8_general_ci"
    t.integer "tagger_id"
    t.string "context", limit: 128, collation: "utf8_general_ci"
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

  create_table "template_cards", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4" do |t|
    t.integer "account_id"
    t.string "name", collation: "utf8_general_ci"
    t.string "elevator_pitch", collation: "utf8_general_ci"
    t.text "description", collation: "utf8_general_ci"
    t.string "global_slug", collation: "utf8_general_ci"
    t.boolean "is_current_version"
    t.string "slug", collation: "utf8_general_ci"
    t.string "version_series", collation: "utf8_general_ci"
    t.integer "previous_version_id"
    t.string "version_genre", collation: "utf8_general_ci"
    t.string "version", collation: "utf8_general_ci"
    t.text "change_log", collation: "utf8_general_ci"
    t.string "status", collation: "utf8_general_ci"
    t.integer "publish_count"
    t.boolean "is_public"
    t.text "git_url", collation: "utf8_general_ci"
    t.string "git_branch", default: "master", collation: "utf8_general_ci"
    t.integer "created_by"
    t.integer "updated_by"
    t.integer "template_datum_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "has_static_image", default: false
    t.string "git_repo_name", collation: "utf8_general_ci"
    t.string "s3_identifier", collation: "utf8_general_ci"
    t.boolean "has_multiple_uploads", default: false
    t.boolean "has_grouping", default: false
    t.text "allowed_views", collation: "utf8_general_ci"
    t.integer "sort_order"
    t.index ["slug"], name: "index_template_cards_on_slug", unique: true
  end

  create_table "template_data", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4" do |t|
    t.string "name", collation: "utf8_general_ci"
    t.string "global_slug", collation: "utf8_general_ci"
    t.string "slug", collation: "utf8_general_ci"
    t.string "version", collation: "utf8_general_ci"
    t.text "change_log", collation: "utf8_general_ci"
    t.integer "publish_count"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "s3_identifier", collation: "utf8_general_ci"
    t.string "status", collation: "utf8_general_ci"
    t.integer "created_by"
    t.integer "updated_by"
    t.index ["slug"], name: "index_template_data_on_slug", unique: true
  end

  create_table "template_pages", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4" do |t|
    t.string "name", collation: "utf8_general_ci"
    t.text "description", collation: "utf8_general_ci"
    t.text "global_slug", collation: "utf8_general_ci"
    t.boolean "is_current_version"
    t.string "slug", collation: "utf8_general_ci"
    t.string "version_series", collation: "utf8_general_ci"
    t.integer "previous_version_id"
    t.string "version_genre", collation: "utf8_general_ci"
    t.string "version", collation: "utf8_general_ci"
    t.text "change_log", collation: "utf8_general_ci"
    t.string "status", collation: "utf8_general_ci"
    t.integer "publish_count"
    t.boolean "is_public"
    t.string "git_url", collation: "utf8_general_ci"
    t.string "git_branch", collation: "utf8_general_ci"
    t.string "git_repo_name", collation: "utf8_general_ci"
    t.string "s3_identifier", collation: "utf8_general_ci"
    t.integer "created_by"
    t.integer "updated_by"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "account_id"
  end

  create_table "uploads", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4" do |t|
    t.string "attachment", collation: "utf8_general_ci"
    t.bigint "template_card_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "account_id"
    t.bigint "folder_id"
    t.integer "created_by"
    t.integer "updated_by"
    t.text "upload_errors", collation: "utf8_general_ci"
    t.text "filtering_errors", collation: "utf8_general_ci"
    t.string "upload_status", default: "waiting", collation: "utf8_general_ci"
    t.integer "total_rows"
    t.integer "rows_uploaded"
    t.integer "site_id"
    t.index ["account_id"], name: "index_uploads_on_account_id"
    t.index ["folder_id"], name: "index_uploads_on_folder_id"
    t.index ["template_card_id"], name: "index_uploads_on_template_card_id"
  end

  create_table "user_emails", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4" do |t|
    t.bigint "user_id"
    t.string "email", collation: "utf8_general_ci"
    t.string "confirmation_token", collation: "utf8_general_ci"
    t.datetime "confirmation_sent_at"
    t.datetime "confirmed_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "is_primary_email"
    t.index ["user_id"], name: "index_user_emails_on_user_id"
  end

  create_table "user_sessions", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string "session_id"
    t.integer "user_id"
    t.string "ip"
    t.string "user_agent"
    t.string "location_city"
    t.string "location_state"
    t.string "location_country"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "users", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4" do |t|
    t.string "name", default: "", null: false, collation: "utf8_general_ci"
    t.string "email", default: "", null: false, collation: "utf8_general_ci"
    t.string "access_token", collation: "utf8_general_ci"
    t.string "encrypted_password", default: "", null: false, collation: "utf8_general_ci"
    t.string "reset_password_token", collation: "utf8_general_ci"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer "sign_in_count", default: 0, null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string "current_sign_in_ip", collation: "utf8_general_ci"
    t.string "last_sign_in_ip", collation: "utf8_general_ci"
    t.string "confirmation_token", collation: "utf8_general_ci"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string "unconfirmed_email", collation: "utf8_general_ci"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "can_publish_link_sources", default: false
    t.text "bio"
    t.text "website"
    t.text "facebook"
    t.text "twitter"
    t.string "phone"
    t.text "linkedin"
    t.index ["confirmation_token"], name: "index_users_on_confirmation_token", unique: true
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  create_table "view_casts", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4" do |t|
    t.integer "account_id"
    t.string "datacast_identifier", collation: "utf8_general_ci"
    t.integer "template_card_id"
    t.integer "template_datum_id"
    t.string "name", collation: "utf8_general_ci"
    t.text "optionalConfigJSON", collation: "utf8_general_ci"
    t.string "slug", collation: "utf8_general_ci"
    t.integer "created_by"
    t.integer "updated_by"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.text "seo_blockquote", collation: "utf8_general_ci"
    t.text "status", collation: "utf8_general_ci"
    t.integer "folder_id"
    t.boolean "is_invalidating"
    t.string "default_view", collation: "utf8_general_ci"
    t.string "genre", collation: "utf8_general_ci"
    t.string "sub_genre", collation: "utf8_general_ci"
    t.string "series", collation: "utf8_general_ci"
    t.string "by_line", collation: "utf8_general_ci"
    t.integer "site_id"
    t.boolean "is_open"
    t.boolean "is_autogenerated", default: false
    t.boolean "is_disabled_for_edit", default: false
    t.integer "byline_id"
    t.integer "ref_category_intersection_id"
    t.integer "ref_category_sub_intersection_id"
    t.integer "ref_category_vertical_id"
    t.index ["slug"], name: "index_view_casts_on_slug", unique: true
  end

  add_foreign_key "uploads", "accounts"
  add_foreign_key "uploads", "folders"
  add_foreign_key "uploads", "template_cards"
  add_foreign_key "user_emails", "users"
end
