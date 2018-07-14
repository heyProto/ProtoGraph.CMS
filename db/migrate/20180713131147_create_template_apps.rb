class CreateTemplateApps < ActiveRecord::Migration[5.1]
  def change
    create_table :template_apps do |t|
      t.integer :site_id
      t.string :name
      t.string :genre
      t.string :pitch
      t.text :description
      t.boolean :is_public
      t.integer :installs
      t.bigint :views
      t.text :change_log
      t.text :git_url
      t.boolean :is_system_installed
      t.integer :created_by
      t.integer :updated_by
      t.boolean :is_backward_compatible, default: false
      t.integer :publish_count
      t.timestamps
    end

    add_column :template_cards, :template_app_id, :integer
    add_column :template_pages, :template_app_id, :integer
    add_column :template_data, :template_app_id, :integer


    TemplateApp.delete_all
    TemplateCard.all.each do |d|
      t = TemplateApp.create({
        site_id: d.site_id,
        name: d.name,
        slug: d.slug,
        pitch: d.elevator_pitch,
        description: d.description,
        git_url: d.git_url,
        is_system_installed: d.is_system,
        is_public: d.is_public,
        created_by: d.created_by,
        updated_by: d.updated_by,
        change_log: d.change_log,
        publish_count: d.publish_count,
        genre: "card"
      })

      d.update_column(:template_app_id,  t.id)
    end

    TemplateDatum.all.each do |d|
      t = TemplateApp.create({
        site_id: d.site_id,
        name: d.name,
        slug: d.slug,
        created_by: d.created_by,
        updated_by: d.updated_by,
        change_log: d.change_log,
        publish_count: d.publish_count,
        genre: "datum"
      })
      d.update_column(:template_app_id,  t.id)
    end

    TemplatePage.all.each do |d|
      t = TemplateApp.create({
        site_id: d.site_id,
        name: d.name,
        slug: d.slug,
        description: d.description,
        git_url: d.git_url,
        is_system_installed: d.is_system,
        is_public: d.is_public,
        created_by: d.created_by,
        updated_by: d.updated_by,
        change_log: d.change_log,
        publish_count: d.publish_count,
        genre: "page"
      })

      d.update_column(:template_app_id,  t.id)
    end


    remove_column :template_cards, :elevator_pitch, :string
    remove_column :template_cards, :description, :text
    remove_column :template_cards, :change_log, :text
    remove_column :template_cards, :is_public, :boolean
    remove_column :template_cards, :git_url, :text
    remove_column :template_cards, :is_system, :boolean
    remove_column :template_pages, :git_branch, :text
    remove_column :template_cards, :publish_count, :integer

    remove_column :template_pages, :description, :text
    remove_column :template_pages, :change_log, :text
    remove_column :template_pages, :is_public, :boolean
    remove_column :template_pages, :git_url, :text
    remove_column :template_pages, :is_system, :boolean
    remove_column :template_pages, :publish_count, :integer

    remove_column :template_data, :change_log, :text
    remove_column :template_data, :publish_count, :integer

  end
end
