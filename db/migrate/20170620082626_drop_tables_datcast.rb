class DropTablesDatcast < ActiveRecord::Migration[5.1]
  def change
    drop_table :datacasts
    drop_table :datacast_accounts
  end
end
