class RemoveRefRoles < ActiveRecord::Migration[5.1]
  def change
    require 'rake'
    Rake::Task['user_permissions:reduce_roles'].invoke
    drop_table :ref_roles
  end
end
