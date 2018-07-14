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

ActiveRecord::Schema.define(version: 20180714031613) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "ad_integrations", force: :cascade do |t|
    t.bigint "site_id"
    t.bigint "stream_id"
    t.bigint "page_id"
    t.bigint "sort_order"
    t.string "div_id", limit: 255
    t.bigint "height"
    t.bigint "width"
    t.text "slot_text"
    t.bigint "page_stream_id"
    t.bigint "created_by"
    t.bigint "updated_by"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "colour_swatches", force: :cascade do |t|
    t.bigint "red"
    t.bigint "green"
    t.bigint "blue"
    t.bigint "image_id"
    t.boolean "is_dominant", default: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "name", limit: 255
  end

  create_table "feed_links", force: :cascade do |t|
    t.bigint "ref_category_id"
    t.bigint "feed_id"
    t.bigint "view_cast_id"
    t.text "link"
    t.text "headline"
    t.datetime "published_at"
    t.text "description"
    t.text "cover_image"
    t.string "author", limit: 255
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "feeds", force: :cascade do |t|
    t.bigint "ref_category_id"
    t.text "rss"
    t.datetime "last_refreshed_at"
    t.bigint "created_by"
    t.bigint "updated_by"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.datetime "next_refreshed_scheduled_for"
    t.text "custom_errors"
  end

  create_table "folders", force: :cascade do |t|
    t.string "name", limit: 255
    t.string "slug", limit: 255
    t.bigint "created_by"
    t.bigint "updated_by"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "is_trash", default: false
    t.bigint "site_id"
    t.boolean "is_open"
    t.bigint "ref_category_vertical_id"
    t.boolean "is_archived"
    t.boolean "is_for_stories"
  end

  create_table "friendly_id_slugs", force: :cascade do |t|
    t.string "slug", limit: 255
    t.bigint "sluggable_id", null: false
    t.string "sluggable_type", limit: 50
    t.string "scope", limit: 255
    t.datetime "created_at"
    t.index ["slug", "sluggable_type", "scope"], name: "idx_80771_index_friendly_id_slugs_on_slug_and_sluggable_type_an", unique: true
    t.index ["slug", "sluggable_type"], name: "idx_80771_index_friendly_id_slugs_on_slug_and_sluggable_type"
    t.index ["sluggable_id"], name: "idx_80771_index_friendly_id_slugs_on_sluggable_id"
    t.index ["sluggable_type"], name: "idx_80771_index_friendly_id_slugs_on_sluggable_type"
  end

  create_table "image_variations", force: :cascade do |t|
    t.bigint "image_id"
    t.text "image_key"
    t.bigint "image_width"
    t.bigint "image_height"
    t.text "thumbnail_url"
    t.text "thumbnail_key"
    t.bigint "thumbnail_width"
    t.bigint "thumbnail_height"
    t.boolean "is_original"
    t.bigint "created_by"
    t.bigint "updated_by"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "mode", limit: 255
    t.boolean "is_social_image"
    t.boolean "is_smart_cropped", default: false
    t.bigint "site_id"
    t.index ["site_id"], name: "index_image_variations_on_site_id"
  end

  create_table "images", force: :cascade do |t|
    t.string "name", limit: 255
    t.text "description"
    t.string "s3_identifier", limit: 255
    t.text "thumbnail_url"
    t.text "thumbnail_key"
    t.bigint "thumbnail_width"
    t.bigint "thumbnail_height"
    t.bigint "image_width"
    t.bigint "image_height"
    t.string "image", limit: 255
    t.bigint "created_by"
    t.bigint "updated_by"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "is_logo", default: false
    t.boolean "is_favicon", default: false
    t.boolean "is_cover"
    t.string "credits", limit: 255
    t.text "credit_link"
    t.bigint "site_id"
    t.index ["site_id"], name: "index_images_on_site_id"
  end

  create_table "page_streams", force: :cascade do |t|
    t.bigint "page_id"
    t.bigint "stream_id"
    t.bigint "created_by"
    t.bigint "updated_by"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "name_of_stream", limit: 255
    t.bigint "site_id"
    t.bigint "folder_id"
  end

  create_table "pages", force: :cascade do |t|
    t.bigint "site_id"
    t.bigint "folder_id"
    t.string "headline", limit: 255
    t.string "meta_keywords", limit: 255
    t.text "meta_description"
    t.text "summary"
    t.text "cover_image_url_facebook"
    t.text "cover_image_url_square"
    t.string "cover_image_alignment", limit: 255
    t.boolean "is_sponsored"
    t.boolean "is_interactive"
    t.boolean "has_data"
    t.boolean "has_image_other_than_cover"
    t.boolean "has_audio"
    t.boolean "has_video"
    t.datetime "published_at"
    t.text "url"
    t.bigint "ref_category_series_id"
    t.bigint "ref_category_intersection_id"
    t.bigint "ref_category_sub_intersection_id"
    t.bigint "view_cast_id"
    t.text "page_object_url"
    t.bigint "created_by"
    t.bigint "updated_by"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "datacast_identifier", limit: 255
    t.boolean "is_open"
    t.bigint "template_page_id"
    t.string "slug", limit: 255
    t.string "english_headline", limit: 255
    t.string "status", limit: 255
    t.bigint "cover_image_id"
    t.bigint "cover_image_id_7_column"
    t.date "due"
    t.text "description"
    t.bigint "cover_image_id_4_column"
    t.bigint "cover_image_id_3_column"
    t.bigint "cover_image_id_2_column"
    t.string "cover_image_credit", limit: 255
    t.text "share_text_facebook"
    t.text "share_text_twitter"
    t.string "one_line_concept", limit: 255
    t.text "content"
    t.bigint "byline_id"
    t.string "reported_from_country", limit: 255
    t.string "reported_from_state", limit: 255
    t.string "reported_from_district", limit: 255
    t.string "reported_from_city", limit: 255
    t.boolean "hide_byline", default: false
    t.bigint "landing_card_id"
    t.string "external_identifier"
    t.string "html_key"
    t.string "format"
    t.string "importance", default: "low"
  end

  create_table "permission_invites", force: :cascade do |t|
    t.bigint "permissible_id"
    t.string "email", limit: 255
    t.string "ref_role_slug", limit: 255
    t.bigint "created_by"
    t.bigint "updated_by"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "permissible_type", limit: 255
    t.string "name", limit: 255
    t.boolean "create_user"
    t.boolean "do_not_email_user"
  end

  create_table "permission_roles", force: :cascade do |t|
    t.bigint "created_by"
    t.bigint "updated_by"
    t.string "name", limit: 255
    t.string "slug", limit: 255
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

  create_table "permissions", force: :cascade do |t|
    t.bigint "user_id"
    t.bigint "permissible_id"
    t.string "ref_role_slug", limit: 255
    t.string "status", limit: 255
    t.bigint "created_by"
    t.bigint "updated_by"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "is_hidden", default: false
    t.string "permissible_type", limit: 255
    t.bigint "stream_id"
    t.text "stream_url"
    t.text "bio"
    t.text "meta_description"
    t.string "name", limit: 255
  end

  create_table "ref_categories", force: :cascade do |t|
    t.bigint "site_id"
    t.string "genre", limit: 255
    t.string "name", limit: 255
    t.text "stream_url"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "stream_id"
    t.boolean "is_disabled"
    t.bigint "created_by"
    t.bigint "updated_by"
    t.bigint "count", default: 0
    t.text "name_html"
    t.string "slug", limit: 255
    t.string "english_name", limit: 255
    t.text "vertical_page_url"
    t.text "description"
    t.text "keywords"
    t.boolean "show_by_publisher_in_header", default: true
  end

  create_table "sessions", force: :cascade do |t|
    t.string "session_id", limit: 255, null: false
    t.text "data"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "site_template_apps", force: :cascade do |t|
    t.integer "site_id"
    t.integer "template_app_id"
    t.string "status"
    t.datetime "invited_at"
    t.integer "invited_by"
    t.integer "created_by"
    t.integer "updated_by"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "site_vertical_navigations", force: :cascade do |t|
    t.bigint "site_id"
    t.bigint "ref_category_vertical_id"
    t.string "name", limit: 255
    t.text "url"
    t.boolean "launch_in_new_window"
    t.bigint "created_by"
    t.bigint "updated_by"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "sort_order"
    t.string "menu", limit: 255
  end

  create_table "sites", force: :cascade do |t|
    t.string "name", limit: 255
    t.string "domain", limit: 255
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.text "description"
    t.string "primary_language", limit: 255
    t.text "default_seo_keywords"
    t.string "house_colour", limit: 255
    t.string "reverse_house_colour", limit: 255
    t.string "font_colour", limit: 255
    t.string "reverse_font_colour", limit: 255
    t.text "stream_url"
    t.bigint "stream_id"
    t.string "cdn_provider", limit: 255
    t.string "cdn_id", limit: 255
    t.text "host"
    t.text "cdn_endpoint"
    t.string "client_token", limit: 255
    t.string "access_token", limit: 255
    t.string "client_secret", limit: 255
    t.string "g_a_tracking_id", limit: 255
    t.bigint "favicon_id"
    t.bigint "logo_image_id"
    t.string "story_card_style", limit: 255
    t.string "header_background_color", limit: 255
    t.text "header_url"
    t.string "header_positioning", limit: 255
    t.string "slug", limit: 255
    t.boolean "is_english", default: true
    t.string "english_name", limit: 255
    t.boolean "story_card_flip", default: false
    t.bigint "created_by"
    t.bigint "updated_by"
    t.string "seo_name", limit: 255
    t.boolean "is_lazy_loading_activated", default: true
    t.text "comscore_code"
    t.string "gtm_id", limit: 255
    t.boolean "is_smart_crop_enabled", default: false
    t.boolean "enable_ads", default: false
    t.boolean "show_proto_logo", default: true
    t.string "tooltip_on_logo_in_masthead", limit: 255
  end

  create_table "stream_entities", force: :cascade do |t|
    t.bigint "stream_id"
    t.string "entity_type", limit: 255
    t.string "entity_value", limit: 255
    t.boolean "is_excluded"
    t.bigint "created_by"
    t.bigint "updated_by"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "sort_order"
  end

  create_table "streams", force: :cascade do |t|
    t.string "title", limit: 255
    t.string "slug", limit: 255
    t.text "description"
    t.bigint "folder_id"
    t.string "datacast_identifier", limit: 255
    t.bigint "created_by"
    t.bigint "updated_by"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "card_count"
    t.datetime "last_published_at"
    t.string "order_by_key", limit: 255
    t.string "order_by_value", limit: 255
    t.bigint "limit"
    t.bigint "offset"
    t.boolean "is_grouped_data_stream", default: false
    t.string "data_group_key", limit: 255
    t.boolean "include_data", default: false
    t.string "order_by_type", limit: 255
    t.bigint "site_id"
    t.boolean "is_automated_stream", default: false
    t.string "col_name", limit: 255
    t.bigint "col_id"
    t.boolean "is_open"
    t.index "to_tsvector('simple'::regconfig, (title)::text)", name: "idx_80902_index_streams_on_title", using: :gin
    t.index "to_tsvector('simple'::regconfig, description)", name: "idx_80902_index_streams_on_description", using: :gin
  end

  create_table "template_apps", force: :cascade do |t|
    t.integer "site_id"
    t.string "name"
    t.string "slug"
    t.string "genre"
    t.string "pitch"
    t.text "description"
    t.boolean "is_public"
    t.integer "installs"
    t.bigint "views"
    t.text "change_log"
    t.text "git_url"
    t.boolean "is_system_installed"
    t.integer "created_by"
    t.integer "updated_by"
    t.boolean "is_backward_compatible", default: false
    t.integer "publish_count"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "template_cards", force: :cascade do |t|
    t.string "name", limit: 255
    t.string "global_slug", limit: 255
    t.boolean "is_current_version"
    t.string "slug", limit: 255
    t.string "version_series", limit: 255
    t.bigint "previous_version_id"
    t.string "version_genre", limit: 255
    t.string "version", limit: 255
    t.string "status", limit: 255
    t.string "git_branch", limit: 255
    t.bigint "created_by"
    t.bigint "updated_by"
    t.bigint "template_datum_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "has_static_image", default: false
    t.string "git_repo_name", limit: 255
    t.string "s3_identifier", limit: 255
    t.boolean "has_multiple_uploads", default: false
    t.boolean "has_grouping", default: false
    t.text "allowed_views"
    t.bigint "sort_order"
    t.boolean "is_editable", default: true
    t.bigint "site_id"
    t.integer "template_app_id"
    t.index ["site_id"], name: "index_template_cards_on_site_id"
    t.index ["slug"], name: "idx_80932_index_template_cards_on_slug", unique: true
  end

  create_table "template_data", force: :cascade do |t|
    t.string "name", limit: 255
    t.string "global_slug", limit: 255
    t.string "slug", limit: 255
    t.string "version", limit: 255
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "status", limit: 255
    t.string "s3_identifier", limit: 255
    t.bigint "created_by"
    t.bigint "updated_by"
    t.integer "site_id"
    t.integer "template_app_id"
    t.index ["slug"], name: "idx_80945_index_template_data_on_slug", unique: true
  end

  create_table "template_fields", force: :cascade do |t|
    t.bigint "site_id"
    t.bigint "template_datum_id"
    t.string "key_name"
    t.string "name"
    t.string "data_type"
    t.text "description"
    t.text "help"
    t.boolean "is_entry_title"
    t.string "genre_html"
    t.boolean "is_required", default: false
    t.string "default_value"
    t.text "inclusion_list", array: true
    t.text "inclusion_list_names", array: true
    t.decimal "min"
    t.decimal "max"
    t.decimal "multiple_of"
    t.boolean "ex_min"
    t.boolean "ex_max"
    t.text "format"
    t.string "format_regex"
    t.integer "length_minimum"
    t.integer "length_maximum"
    t.string "slug"
    t.integer "created_by"
    t.integer "updated_by"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "sort_order"
    t.index ["site_id"], name: "index_template_fields_on_site_id"
    t.index ["template_datum_id"], name: "index_template_fields_on_template_datum_id"
  end

  create_table "template_pages", force: :cascade do |t|
    t.string "name", limit: 255
    t.text "global_slug"
    t.boolean "is_current_version"
    t.string "slug", limit: 255
    t.string "version_series", limit: 255
    t.bigint "previous_version_id"
    t.string "version_genre", limit: 255
    t.string "version", limit: 255
    t.string "status", limit: 255
    t.string "git_repo_name", limit: 255
    t.string "s3_identifier", limit: 255
    t.bigint "created_by"
    t.bigint "updated_by"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "site_id"
    t.integer "template_app_id"
  end

  create_table "uploads", force: :cascade do |t|
    t.string "attachment", limit: 255
    t.decimal "template_card_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.decimal "folder_id"
    t.bigint "created_by"
    t.bigint "updated_by"
    t.text "upload_errors"
    t.text "filtering_errors"
    t.string "upload_status", limit: 255
    t.bigint "total_rows"
    t.bigint "rows_uploaded"
    t.bigint "site_id"
    t.index ["folder_id"], name: "idx_80963_index_uploads_on_folder_id"
    t.index ["template_card_id"], name: "idx_80963_index_uploads_on_template_card_id"
  end

  create_table "user_emails", force: :cascade do |t|
    t.decimal "user_id"
    t.string "email", limit: 255
    t.string "confirmation_token", limit: 255
    t.datetime "confirmation_sent_at"
    t.datetime "confirmed_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "is_primary_email"
    t.index ["user_id"], name: "idx_80983_index_user_emails_on_user_id"
  end

  create_table "user_sessions", force: :cascade do |t|
    t.string "session_id", limit: 255
    t.bigint "user_id"
    t.string "ip", limit: 255
    t.string "user_agent", limit: 255
    t.string "location_city", limit: 255
    t.string "location_state", limit: 255
    t.string "location_country", limit: 255
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "latitude", limit: 255
    t.string "longitude", limit: 255
    t.string "time_zone", limit: 255
    t.string "zip_code", limit: 255
  end

  create_table "users", force: :cascade do |t|
    t.string "name", limit: 255
    t.string "email", limit: 255
    t.string "access_token", limit: 255
    t.string "encrypted_password", limit: 255
    t.string "reset_password_token", limit: 255
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.bigint "sign_in_count", default: 0, null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string "current_sign_in_ip", limit: 255
    t.string "last_sign_in_ip", limit: 255
    t.string "confirmation_token", limit: 255
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string "unconfirmed_email", limit: 255
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "can_publish_link_sources", default: false
    t.text "bio"
    t.text "website"
    t.text "facebook"
    t.text "twitter"
    t.string "phone", limit: 255
    t.text "linkedin"
    t.index ["confirmation_token"], name: "idx_80972_index_users_on_confirmation_token", unique: true
    t.index ["email"], name: "idx_80972_index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "idx_80972_index_users_on_reset_password_token", unique: true
  end

  create_table "view_casts", force: :cascade do |t|
    t.string "datacast_identifier", limit: 255
    t.bigint "template_card_id"
    t.bigint "template_datum_id"
    t.string "name", limit: 255
    t.text "optionalconfigjson"
    t.string "slug", limit: 255
    t.bigint "created_by"
    t.bigint "updated_by"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.text "seo_blockquote"
    t.text "status"
    t.bigint "folder_id"
    t.boolean "is_invalidating"
    t.string "default_view", limit: 255
    t.string "by_line", limit: 255
    t.bigint "site_id"
    t.boolean "is_open"
    t.boolean "is_autogenerated", default: false
    t.boolean "is_disabled_for_edit", default: false
    t.bigint "byline_id"
    t.bigint "ref_category_intersection_id"
    t.bigint "ref_category_sub_intersection_id"
    t.bigint "ref_category_vertical_id"
    t.datetime "published_at"
    t.json "data_json"
    t.string "external_identifier"
    t.string "format"
    t.string "importance", default: "low"
    t.index ["slug"], name: "idx_81001_index_view_casts_on_slug", unique: true
  end

  add_foreign_key "image_variations", "sites"
  add_foreign_key "images", "sites"
  add_foreign_key "template_cards", "sites"
  add_foreign_key "template_fields", "sites"
  add_foreign_key "template_fields", "template_data"
end
