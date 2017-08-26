class AddPiwikMethodToPiwikMetric < ActiveRecord::Migration[5.1]
  def change
    add_column :piwik_metrics, :piwik_metric_type, :string
    rename_column :piwik_metrics, :module, :piwik_module
    rename_column :piwik_metrics, :metric, :piwik_metric_name
    rename_column :piwik_metrics, :value, :piwik_metric_value
  end
end
