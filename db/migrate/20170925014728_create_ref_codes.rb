class CreateRefCodes < ActiveRecord::Migration[5.1]
  def change
    create_table :ref_codes do |t|
      t.integer :account_id
      t.string :key
      t.string :val
      t.boolean :is_default
      t.integer :sort_order
      t.integer :created_by
      t.integer :updated_by

      t.timestamps
    end
  end
end
