class RemoveAccountIdFromAudioVariations < ActiveRecord::Migration[5.1]
  def change
    remove_column :audio_variations, :account_id
  end
end
