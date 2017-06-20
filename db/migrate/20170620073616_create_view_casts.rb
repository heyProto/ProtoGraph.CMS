class CreateViewCasts < ActiveRecord::Migration[5.1]
  def change
    create_table :view_casts do |t|
      t.integer :account_id
      t.string :datacast_identifier
      t.integer :template_card_id
      t.integer :template_datum_id
      t.string :name
      t.text :configJSON
      t.text :cdn_url
      t.string :slug
      t.integer :created_by
      t.integer :updated_by

      t.timestamps
    end
  end
end
