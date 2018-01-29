class AddColumnInPage < ActiveRecord::Migration[5.1]
  def change
    add_column :pages, :slug, :string

    Page.all.each(&:save)
  end
end
