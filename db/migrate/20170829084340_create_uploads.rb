class CreateUploads < ActiveRecord::Migration[5.1]
  def change
    create_table :uploads do |t|
      t.string :attachment
      t.references :template_card, foreign_key: true

      t.timestamps
    end
  end
end
