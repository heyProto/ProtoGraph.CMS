class PiwikApi < ApplicationRecord
  # All from_data and to_date are in the form of
  # "yyyy-mm-dd". to_date can also take keywords
  # "today", "yesterday"
  #
  # period: "day", "year", "month", "range"
  # segment: check piwik documentation at
  #
  PIWIK_BASE_URL = "https://protograph.innocraft.cloud"
  class << self

    def get_event(from_date,
                  to_date,
                  segment="",
                  event_method_1="Name",
                  event_method_2="Action")
      response = RestClient::Request.execute(
        method: "get",
        url: PIWIK_BASE_URL,
        headers: {
          params: {
            module: "API",
            format: "json",
            idSite: ENV["PIWIK_ID_SITE"],
            token_auth: ENV["PIWIK_TOKEN_AUTH"],
            period: "range",
            date: from_date + "," + to_date,
            method: "Events.get#{event_method_1}",
            segment: segment,
            secondaryDimension: "event#{event_method_2}",
            flat: 1,
          }
        }
      )
      begin
        return JSON.parse(response)
      rescue Exception => e
        return { success: false }
      end
    end

    def get_visitor_details(from_date, to_date, period="range", segment="")
      response = RestClient::Request.execute(
        method: "get",
        url: PIWIK_BASE_URL,
        headers: {
          params: {
            module: "API",
            format: "json",
            idSite: ENV["PIWIK_ID_SITE"],
            token_auth: ENV["PIWIK_TOKEN_AUTH"],
            period: "range",
            method: "VisitsSummary.get",
            date: from_date + "," + to_date,
            segment: segment
          }
        }
      )
      begin
        return JSON.parse(response)
      rescue Exception => e
        return { success: false }
      end
    end

    def get_unique_visitor_count(from_date, to_date)
      response = RestClient::Request.execute(
        method: "get",
        url: PIWIK_BASE_URL,
        headers: {
          params: {
            module: "API",
            format: "json",
            idSite: ENV["PIWIK_ID_SITE"],
            token_auth: ENV["PIWIK_TOKEN_AUTH"],
            period: "range",
            method: "VisitsSummary.getUniqueVisitors",
            date: from_date + "," + to_date,
          }
        }
      )
      begin
        return JSON.parse(response)
      rescue Exception => e
        return { success: false }
      end
    end

    def get_actions(from_date, to_date)
      response = RestClient::Request.execute(
        method: "get",
        url: PIWIK_BASE_URL,
        headers: {
          params: {
            module: "API",
            format: "json",
            idSite: ENV["PIWIK_ID_SITE"],
            token_auth: ENV["PIWIK_TOKEN_AUTH"],
            period: "range",
            method: "VisitsSummary.getActions",
            date: from_date + "," + to_date,
          }
        }
      )
      begin
        return JSON.parse(response)
      rescue Exception => e
        return { success: false }
      end
    end

    def get_total_time_spent(from_date, to_date)
      response = RestClient::Request.execute(
        method: "get",
        url: PIWIK_BASE_URL,
        headers: {
          params: {
            module: "API",
            format: "json",
            idSite: ENV["PIWIK_ID_SITE"],
            token_auth: ENV["PIWIK_TOKEN_AUTH"],
            period: "range",
            method: "VisitsSummary.getSumVisitsLength",
            date: from_date + "," + to_date,
          }
        }
      )
      begin
        return JSON.parse(response)
      rescue Exception => e
        return { success: false }
      end
    end

    def get_average_time_spent(from_date, to_date)
      total_time_spent = self.get_total_time_spent(from_date, to_date)["value"]
      visitor_count = self.get_visitor_count(from_date, to_date)["value"]
      begin
        return {value: total_time_spent / visitor_count}
      rescue Exception => e
        return { success: false }
      end
    end

    def get_all_custom_dimensions
      response = RestClient::Request.execute(
        method: "get",
        url: PIWIK_BASE_URL,
        headers: {
          params: {
            module: "API",
            format: "json",
            idSite: ENV["PIWIK_ID_SITE"],
            token_auth: ENV["PIWIK_TOKEN_AUTH"],
            method: "CustomDimensions.getConfiguredCustomDimensions",
          }
        }
      )
      begin
        return JSON.parse(response)
      rescue Exception => e
        return { success: false }
      end
    end

    def get_custom_dimension(from_date, to_date, dimension_id, segment="")
      response = RestClient::Request.execute(
        method: "get",
        url: PIWIK_BASE_URL,
        headers: {
          params: {
            module: "API",
            format: "json",
            period: "range",
            date: from_date + "," + to_date,
            idSite: ENV["PIWIK_ID_SITE"],
            token_auth: ENV["PIWIK_TOKEN_AUTH"],
            method: "CustomDimensions.getConfiguredCustomDimensions",
            idDimension: dimension_id,
            segment: segment
          }
        }
      )
      begin
        return JSON.parse(response)
      rescue Exception => e
        return { success: false }
      end
    end
  end
end


# params = {"module":"API",
#           "format":"json",
#           "idSite":2,
#           "period":"range",
#           "date":"2017-01-01,today",
#           "method":"API.getBulkRequest",
#           "token_auth":"f98eeca65e642f5c045eea3fd5f62487",
#           "urls[1]":"method=VisitsSummary.getVisits",
#           "urls[2]":"method=VisitsSummary.getSumVisitsLengthPretty",
#           "urls[3]":"method=VisitorInterest.getNumberOfVisitsPerVisitDuration",
#           "urls[4]":"method=Referrers.getAll",
#           "urls[5]":"method=CustomDimensions.getCustomDimension",
#           "idDimension":1,
# }
