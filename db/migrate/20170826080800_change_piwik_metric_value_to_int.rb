class ChangePiwikMetricValueToInt < ActiveRecord::Migration[5.1]
  def change
    change_column :piwik_metrics, :piwik_metric_value, :integer
  end
end
