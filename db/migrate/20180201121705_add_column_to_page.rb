class AddColumnToPage < ActiveRecord::Migration[5.1]
  def change
    add_column :pages, :status, :string

    Page.where(is_published: true).update_all(status: 'published')
    Page.where.not(is_published: true).update_all(status: 'unlisted')
    remove_column :pages, :is_published, :boolean
  end
end
