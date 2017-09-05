class AddIsLogoColumnToImages < ActiveRecord::Migration[5.1]
  def change
    add_column :images, :is_logo, :boolean, default: false
  end
end
