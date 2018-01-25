class CreateSites < ActiveRecord::Migration[5.1]
  def change

    # Removing some old features

    drop_table :ref_codes
    drop_table :articles
    drop_table :piwik_metrics
    drop_table :tags

    remove_column :view_casts, :article_id
    Activity.where(trackable_type: "Article").delete_all

    # Sites
    create_table :sites do |t|
      t.integer :account_id
      t.string :name
      t.string :domain

      t.timestamps
    end

    Account.all.each do |account|
      Site.create({
          account_id: account.id,
          name: account.username,
          domain: account.domain
      )}
    end

    # Adding Site Id
    add_column :activities, :site_id, :integer
    add_column :authentications, :site_id, :integer
    add_column :folders, :site_id, :integer
    add_column :streams, :site_id, :integer
  end
end
