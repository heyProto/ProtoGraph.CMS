class AddColumns123ToViewCast < ActiveRecord::Migration[5.1]
  def change
    add_column :view_casts, :article_id, :integer

    Article.all.each do |article|
        article.article_card.update_column(:article_id, article.id)
    end
  end
end
