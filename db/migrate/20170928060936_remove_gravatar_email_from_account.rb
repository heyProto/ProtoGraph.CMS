class RemoveGravatarEmailFromAccount < ActiveRecord::Migration[5.1]
  def change
    remove_column :accounts, :gravatar_email
  end
end
