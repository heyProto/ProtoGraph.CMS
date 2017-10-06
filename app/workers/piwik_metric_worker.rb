class PiwikDatacastMetricWorker
  include Sidekiq::Worker
  sidekiq_options backtrace: true

  def perform(datacast_identifier)
    view_cast = ViewCast.find_by(datacast_identifier: datacast_identifier)
    metrics = PiwikApi.get_visitor_details("2017-01-01", "today", segment="eventName==#{datacast_identifier}")
    unless metrics["result"] == "error"
      ### Total card visits
      PiwikMetric.create_or_update(datacast_identifier, "VisitsSummary", "total_visits", piwik_metric_value=metrics["nb_visits"])

      ### Card unique visits
      unless metrics["nb_uniq_visitors"].nil?
        PiwikMetric.create_or_update(datacast_identifier, "VisitsSummary", "unique_visits", piwik_metric_value=metrics["nb_visits"])        
      end

      ### Average
      unless metrics["avg_time_on_site"].nil?
        PiwikMetric.create_or_update(datacast_identifier, "VisitsSummary", "average_time_spent", piwik_metric_value=metrics["avg_time_on_site"])        
      end
    end
  end
end
