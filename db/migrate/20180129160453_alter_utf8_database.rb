class AlterUtf8Database < ActiveRecord::Migration[5.1]

  def db
    ActiveRecord::Base.connection
  end

  def up
    db.execute "ALTER DATABASE `#{db.current_database}` CHARACTER SET utf8 COLLATE utf8_bin;"
    db.tables.each do |table|
      db.execute "ALTER TABLE `#{table}` CHARACTER SET = utf8 COLLATE utf8_bin;"
      db.columns(table).each do |column|
        case column.sql_type
        when "text"
          db.execute "ALTER TABLE `#{table}` CHANGE `#{column.name}` `#{column.name}` TEXT CHARACTER SET utf8 COLLATE utf8_bin;"
        when /varchar\(([0-9]+)\)/i
          # InnoDB has a maximum index length of 767 bytes, so for utf8 or utf8mb4
          # columns, you can index a maximum of 255 or 191 characters, respectively.
          # If you currently have utf8 columns with indexes longer than 191 characters,
          # you will need to index a smaller number of characters.
          indexed_column = db.indexes(table).any? { |index| index.columns.include?(column.name) }
          sql_type = (indexed_column && $1.to_i > 255) ? "VARCHAR(255)" : column.sql_type.upcase
          db.execute "ALTER TABLE `#{table}` CHANGE `#{column.name}` `#{column.name}` #{sql_type} CHARACTER SET utf8 COLLATE utf8_bin;"
        end
      end
    end
  end
end
