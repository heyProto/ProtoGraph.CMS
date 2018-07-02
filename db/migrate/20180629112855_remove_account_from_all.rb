class RemoveAccountFromAll < ActiveRecord::Migration[5.1]
  def change
    ActiveRecord::Base.connection.tables.each do |t|
      if table_exists? t
        if column_exists?(t, :account_id)
          remove_column(t, :account_id)
        else
          puts "#{t.to_s} does not have column account_id"
        end
      else
        puts "#{t.to_s} does not exist"
      end
    end
  end
end
