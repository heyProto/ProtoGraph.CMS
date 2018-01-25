class AddColumns123toViewCast < ActiveRecord::Migration[5.1]
  def change
    add_column :view_casts, :genre, :string
    add_column :view_casts, :sub_genre, :string
    add_column :view_casts, :series, :string
    add_column :view_casts, :by_line, :string
    
    template_card = TemplateCard.where(name: 'toStory').first
    if template_card
      ViewCast.where(template_card_id: template_card.id).each do |view_cast|
          res = JSON.parse(RestClient.get(view_cast.data_url).body)
          data = res['data']
          view_cast.by_line = data["by_line"]
          view_cast.genre = data["genre"]
          view_cast.sub_genre = data["subgenre"]
          view_cast.series = data["series"]
          view_cast.save
      end
    end    
  end
end
