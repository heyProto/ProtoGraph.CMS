class RemoveLayoutFromPages < ActiveRecord::Migration[5.1]
  def change
    add_column :pages, :template_page_id, :integer

    require 'rake'
    puts ">>>>>>>>>>>>> Migrating Data"
    Rake::Task['migrations:migrate_page_layout'].invoke
    puts ">>>>>>>>>>>>> Data Migrated"

    remove_column :pages, :layout
  end
end
