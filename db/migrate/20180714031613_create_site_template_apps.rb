class CreateSiteTemplateApps < ActiveRecord::Migration[5.1]
  def change
    create_table :site_template_apps do |t|
      t.integer :site_id
      t.integer :template_app_id
      t.string :status
      t.datetime :invited_at
      t.integer :invited_by
      t.integer :created_by
      t.integer :updated_by

      t.timestamps
    end
    
    TemplateApp.all.each do |app|
      SiteTemplateApp.create(
        site_id: app.site_id,
        template_app_id: app.id,
        status: "Installed",
        invited_at: nil,
        invited_by: nil,
        created_by: app.created_by,
        updated_by: app.updated_by
      )
    end
    
  end
end
