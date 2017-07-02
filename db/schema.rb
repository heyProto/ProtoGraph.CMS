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

ActiveRecord::Schema.define(version: 20170702135433) do

  create_table "accounts", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string "username"
    t.string "slug"
    t.string "domain"
    t.string "gravatar_email"
    t.string "status"
    t.string "sign_up_mode"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["domain"], name: "index_accounts_on_domain"
    t.index ["slug"], name: "index_accounts_on_slug", unique: true
    t.index ["username"], name: "index_accounts_on_username", unique: true
  end

  create_table "authentications", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.integer "account_id"
    t.string "provider"
    t.string "uid"
    t.text "info"
    t.string "name"
    t.string "email"
    t.string "access_token"
    t.string "access_token_secret"
    t.string "refresh_token"
    t.datetime "token_expires_at"
    t.integer "created_by"
    t.integer "updated_by"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
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
  end

  create_table "ref_roles", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string "name"
    t.string "slug"
    t.boolean "can_account_settings"
    t.boolean "can_template_design_do"
    t.boolean "can_template_design_publish"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "sort_order"
    t.index ["slug"], name: "index_ref_roles_on_slug", unique: true
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
    t.index ["slug"], name: "index_template_cards_on_slug", unique: true
  end

  create_table "template_data", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
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
    t.string "api_key"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["api_key"], name: "index_template_data_on_api_key"
    t.index ["slug"], name: "index_template_data_on_slug", unique: true
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
    t.text "cdn_url"
    t.string "slug"
    t.integer "created_by"
    t.integer "updated_by"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.text "seo_blockquote"
    t.text "render_screenshot_url"
    t.text "status"
  end

end
