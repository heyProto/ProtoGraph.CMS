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

      create_table :permissions do |t|
        t.integer :user_id
        t.integer :account_id
        t.integer :created_by
        t.integer :updated_by

        t.timestamps
      end

      create_table :permission_invites do |t|
        t.integer :account_id
        t.string :email
        t.integer :created_by
        t.integer :updated_by

        t.timestamps
      end

      create_table :accounts do |t|
        t.string :username
        t.string :slug

        t.timestamps
      end
      add_index :accounts, :username, unique: true
      add_index :accounts, :slug, unique: true

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
    end
  end
