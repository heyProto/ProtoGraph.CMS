class AddColsForUniqueIdentification < ActiveRecord::Migration[5.1]
  def change
    add_column :template_cards, :s3_identifier, :string
    add_column :template_data, :s3_identifier, :string

    TemplateCard.all.each do |template_card|
        template_card.update_column(:s3_identifier, SecureRandom.hex(8))
    end

    TemplateDatum.all.each do |template_datum|
        template_datum.update_column(:s3_identifier, SecureRandom.hex(8))
    end
  end
end
