class AddsColumnShowProtoLogoToSites < ActiveRecord::Migration[5.1]
  def change
    add_column :sites, :show_proto_logo, :boolean, default: true
  end
end
