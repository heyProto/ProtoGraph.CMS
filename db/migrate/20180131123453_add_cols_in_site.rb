class AddColsInSite < ActiveRecord::Migration[5.1]
  def change
    add_column :sites, :is_english, :boolean, default: true
    add_column :sites, :english_name, :string
    add_column :ref_categories, :english_name, :string
    add_column :pages, :english_headline, :string

    Site.all.each { |s| s.update(english_name: s.name)  }
    RefCategory.all.each { |s| s.update(english_name: s.name)  }
    Page.all.each { |p| p.update(english_headline: p.headline)  }
  end
end
