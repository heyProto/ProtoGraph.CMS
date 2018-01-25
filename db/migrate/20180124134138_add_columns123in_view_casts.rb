class AddColumns123inViewCasts < ActiveRecord::Migration[5.1]
  def change
    add_column :view_casts, :site_id, :integer
    add_column :view_casts, :is_open, :boolean
    add_column :folders, :is_open, :boolean
    add_column :pages, :is_open, :boolean
    add_column :streams, :is_open, :boolean

    ViewCast.all.each do |view_cast|
        view_cast.update_column(:site_id, view_cast.account.site.id)
    end
  end
end
