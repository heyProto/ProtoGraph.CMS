class ChangeAudioVariationColumnTypes < ActiveRecord::Migration[5.1]
  def change
    remove_column :audio_variations, :integer
    change_column :audio_variations, :audio_id, :integer
  end
end
