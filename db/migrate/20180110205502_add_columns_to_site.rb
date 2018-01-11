class AddColumnsToSite < ActiveRecord::Migration[5.1]
  def change
    add_column :sites, :description, :text
    add_column :sites, :primary_language, :string
    add_column :sites, :default_seo_keywords, :text
    add_column :sites, :house_colour, :string
    add_column :sites, :reverse_house_colour, :string
    add_column :sites, :font_colour, :string
    add_column :sites, :reverse_font_colour, :string
    add_column :sites, :stream_url, :text


    Site.all.each do |site|
        a = site.account
        site.update_attributes(
            house_colour: a.house_colour,
            reverse_house_colour: a.reverse_house_colour,
            font_colour: a.font_colour,
            reverse_font_colour: a.reverse_font_colour
        )
    end
  end
end
