class AddCols232323ToPages < ActiveRecord::Migration[5.1]
  def change
    add_column :pages, :reported_from_country, :string
    add_column :pages, :reported_from_state, :string
    add_column :pages, :reported_from_district, :string
    add_column :pages, :reported_from_city, :string
  end
end
