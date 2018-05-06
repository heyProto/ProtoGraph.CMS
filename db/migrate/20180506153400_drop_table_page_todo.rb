class DropTablePageTodo < ActiveRecord::Migration[5.1]
  def change
    drop_table :page_todos
  end
end
