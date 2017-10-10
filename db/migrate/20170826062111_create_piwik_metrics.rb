class CreatePiwikMetrics < ActiveRecord::Migration[5.1]
  def change
    create_table :piwik_metrics do |t|
      t.string :datacast_identifier
      t.string :module
      t.string :metric
      t.string :value

      t.timestamps
    end
  end
end
