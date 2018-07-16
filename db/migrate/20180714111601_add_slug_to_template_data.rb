class AddSlugToTemplateData < ActiveRecord::Migration[5.1]
  def change
    add_column :template_apps, :slug, :string

    TemplateCard.all.each do |d|
      d.template_app.update_attributes(slug: d.slug, site_id: d.site_id)
    end

    TemplateDatum.all.each do |d|
      d.template_app.update_attributes(slug: d.slug, site_id: d.site_id)
    end

    TemplatePage.all.each do |d|
      d.template_app.update_attributes(slug: d.slug, site_id: d.site_id)
    end
  end
end
