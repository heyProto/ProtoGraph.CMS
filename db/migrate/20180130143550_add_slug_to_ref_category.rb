class AddSlugToRefCategory < ActiveRecord::Migration[5.1]
  def change
    add_column :ref_categories, :slug, :string
    add_column :sites, :slug, :string

    Site.all.each(&:save)
    RefCategory.all.each(&:save)
  end
end
