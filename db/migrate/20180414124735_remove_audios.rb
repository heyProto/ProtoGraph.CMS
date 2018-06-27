class RemoveAudios < ActiveRecord::Migration[5.1]
  def change
    drop_table :audio_variations
    drop_table :audios
  end
end
