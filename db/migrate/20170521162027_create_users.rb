class CreateUsers < ActiveRecord::Migration[5.1]
  def change

    create_table :friendly_id_slugs do |t|
      t.string   :slug,           :null => false
      t.integer  :sluggable_id,   :null => false
      t.string   :sluggable_type, :limit => 50
      t.string   :scope
      t.datetime :created_at
    end

    add_index :friendly_id_slugs, :sluggable_id
    add_index :friendly_id_slugs, [:slug, :sluggable_type]
    add_index :friendly_id_slugs, [:slug, :sluggable_type, :scope], :unique => true
    add_index :friendly_id_slugs, :sluggable_type

    create_table :ref_roles do |t|
      t.string :name
      t.string :slug
      t.boolean :can_account_settings
      t.boolean :can_template_design_do
      t.boolean :can_template_design_publish

      t.timestamps
    end
    add_index :ref_roles, :slug, unique: true
    RefRole.seed

    create_table :permissions do |t|
      t.integer :user_id
      t.integer :account_id
      t.string :ref_role_slug
      t.string :status
      t.integer :created_by
      t.integer :updated_by

      t.timestamps
    end

    create_table :permission_invites do |t|
      t.integer :account_id
      t.string :email
      t.string :ref_role_slug
      t.integer :created_by
      t.integer :updated_by

      t.timestamps
    end

    create_table :accounts do |t|
      t.string :username
      t.string :slug
      t.string :domain
      t.string :gravatar_email
      t.string :status
      t.string :sign_up_mode

      t.timestamps
    end
    add_index :accounts, :username, unique: true
    add_index :accounts, :slug, unique: true
    add_index :accounts, :domain

    create_table :users do |t|
      ## Database authenticatable
      t.string :name,               null: false, default: ""
      t.string :email,              null: false, default: ""
      t.string :access_token
      t.string :encrypted_password, null: false, default: ""

      ## Recoverable
      t.string   :reset_password_token
      t.datetime :reset_password_sent_at

      ## Rememberable
      t.datetime :remember_created_at

      ## Trackable
      t.integer  :sign_in_count, default: 0, null: false
      t.datetime :current_sign_in_at
      t.datetime :last_sign_in_at
      t.string     :current_sign_in_ip
      t.string     :last_sign_in_ip

      ## Confirmable
      t.string   :confirmation_token
      t.datetime :confirmed_at
      t.datetime :confirmation_sent_at
      t.string   :unconfirmed_email # Only if using reconfirmable

      t.timestamps
    end
    add_index :users, :email, unique: true
    add_index "users", :reset_password_token    , unique: true
    add_index "users", :confirmation_token  , unique: true

    create_table :authentications do |t|
      t.integer :account_id
      t.string :provider
      t.string :uid
      t.text :info
      t.string :name
      t.string :email
      t.string :access_token
      t.string :access_token_secret
      t.string :refresh_token
      t.datetime :token_expires_at
      t.integer :created_by
      t.integer :updated_by

      t.timestamps
    end

    create_table :template_data do |t|
      t.integer :account_id
      t.string :name
      t.string :elevator_pitch
      t.text :description
      t.string :global_slug
      t.boolean :is_current_version
      t.string :slug
      t.string :version_series
      t.integer :previous_version_id
      t.string :version_genre
      t.string :version
      t.text :change_log
      t.string :status
      t.integer :publish_count
      t.boolean :is_public
      t.integer :created_by
      t.integer :updated_by
      t.string :api_key

      t.timestamps
    end
    add_index :template_data, :slug, unique: true
    add_index :template_data, :api_key

    create_table :template_cards do |t|
      t.integer :account_id
      t.string :name
      t.string :elevator_pitch
      t.text :description
      t.string :global_slug
      t.boolean :is_current_version
      t.string :slug
      t.string :version_series
      t.integer :previous_version_id
      t.string :version_genre
      t.string :version
      t.text :change_log
      t.string :status
      t.integer :publish_count
      t.boolean :is_public
      t.integer :created_by
      t.integer :updated_by
      t.integer :template_datum_id

      t.timestamps
    end
    add_index :template_cards, :slug, unique: true


    create_table :datacasts do |t|
      t.string :slug
      t.integer :template_datum_id
      t.string :external_identifier
      t.string :status
      t.datetime :data_timestamp
      t.datetime :last_updated_at
      t.string :last_data_hash
      t.integer :count_publish
      t.integer :count_duplicate_calls
      t.integer :count_errors
      t.string :input_source
      t.text :error_messages
      t.text :cdn_url
      t.integer :created_by

      t.timestamps
    end
    add_index :datacasts, :slug, unique: true
    add_index :datacasts, :external_identifier

    create_table :datacast_accounts do |t|
      t.integer :datacast_id
      t.integer :account_id
      t.boolean :is_active

      t.timestamps
    end

  end
end
