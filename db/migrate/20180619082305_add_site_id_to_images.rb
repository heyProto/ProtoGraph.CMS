class AddSiteIdToImages < ActiveRecord::Migration[5.1]
  def change
    add_reference :images, :site, foreign_key: true
  end
end
