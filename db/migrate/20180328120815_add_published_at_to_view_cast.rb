class AddPublishedAtToViewCast < ActiveRecord::Migration[5.1]
  def change
    add_column :view_casts, :published_at, :datetime

    data_column_map = {
        "toStory" => "publishedat",
        "toCluster" => "published_date"
    }

    ViewCast.where(template_card_id: TemplateCard.where(name: ['toStory', 'toCluster']).pluck(:id)).includes(:template_card).each do |view_cast|
        begin
            data = JSON.parse(RestClient.get(view_cast.data_url).body)
        rescue => e
            puts e.to_s
        end
        if (data.present? and data["data"][data_column_map[view_cast.template_card.name]].present?)
            view_cast.update_column(:published_at, Date.parse(data["data"][data_column_map[view_cast.template_card.name]]))
        end
    end
  end
end
