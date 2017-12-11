class AddAudioKeyToAudioVariations < ActiveRecord::Migration[5.1]
  def change
    add_column :audio_variations, :audio_key, :text
  end
end
