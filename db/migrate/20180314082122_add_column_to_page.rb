class AddColumnToPage < ActiveRecord::Migration[5.1]
  def change
    # add_column :pages, :byline_id, :integer
    remove_column :pages, :byline
  end
end
