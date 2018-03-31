class AddColumnsToViewCast < ActiveRecord::Migration[5.1]
  def change
    add_column :view_casts, :ref_category_intersection_id, :integer
    add_column :view_casts, :ref_category_sub_intersection_id, :integer
    add_column :view_casts, :ref_category_vertical_id, :integer

    ViewCast.where(template_card_id: TemplateCard.where(name: "toStory").pluck(:id)).each do |d|
        is_changed = false
        if d.genre.present?
            genre = RefCategory.find_or_create("intersection", d.site_id, d.genre, d.created_by, d.updated_by, d.account_id)
            d.ref_category_intersection_id = genre.id
            is_changed = true
        end
        if d.sub_genre.present?
            sub_genre = RefCategory.find_or_create("sub intersection", d.site_id, d.sub_genre, d.created_by, d.updated_by, d.account_id)
            d.ref_category_sub_intersection_id = sub_genre.id
            is_changed = true
        end
        if d.series.present?
            series = RefCategory.find_or_create("series", d.site_id, d.series, d.created_by, d.updated_by, d.account_id)
            d.ref_category_vertical_id = series.id
            is_changed = true
        end
        d.save! if is_changed
    end


    remove_column :view_casts, :genre
    remove_column :view_casts, :sub_genre
    remove_column :view_casts, :series
  end
end
