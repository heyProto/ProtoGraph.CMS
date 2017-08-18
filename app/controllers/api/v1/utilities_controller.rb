class Api::V1::UtilitiesController < ApiController
  skip_before_action :set_user_from_token, :set_global_objects
  def iframely
    # Captures date in the form of August 17, 2017
    date_regex = /(January|February|March|April|May|June|July|August|September|October|November|December)\s([\d]{1,2}),\s([\d]{4})/
    if params['url'].present?
      url = "http://13.126.206.16:8000/iframely"
      begin
        response = RestClient::Request.execute(
          method: "get",
          url: url,
          headers: {
            params: {
              url: utility_params['url']
            }
          }
        )

        response = JSON.parse(response)
        flat_hash = {}

        response["meta"].each do |meta_attr, val|
          unless meta_attr == "description"
            flat_hash[meta_attr] = val
          end
        end

        desc = response["meta"]["description"]
        flat_hash["description"] = desc[0..desc.index("&mdash") - 1]
        flat_hash["date"] = date_regex.match(desc.strip)[0]

        # This block to get the image from a tweet if present
        if response["links"].present? && response["links"]["thumbnail"].present?
          flat_hash["thumbnail_url"] = response["links"]["thumbnail"][0]["href"]
          if response["links"]["thumbnail"][0]["media"].present?
            flat_hash["thumbnail_height"] = response["links"]["thumbnail"][0]["media"]["height"]
            flat_hash["thumbnail_width"] = response["links"]["thumbnail"][0]["media"]["width"]
          end

        # This block to get picture from an external link in tweet
        elsif response["links"].present? && response["links"]["app"].present?
          # Captures link of form https://t.co/link_id_as_hex
          twitter_link_regex = /(https:\/\/)(t.co)\/([a-zA-Z\d]+)/
          unless twitter_link_regex.match(response["links"]["app"][0]["html"]).nil?
            link = twitter_link_regex.match(response["links"]["app"][0]["html"])[0]
            begin
              response = RestClient::Request.execute(
                method: "get",
                url: url,
                headers: {
                  params: {
                    url: link
                  }
                }
              )

              response = JSON.parse(response)
              if response["links"].present? && response["links"]["thumbnail"].present?
                flat_hash["thumbnail_url"] = response["links"]["thumbnail"][0]["href"]
                if response["links"]["thumbnail"][0]["media"].present?
                  flat_hash["thumbnail_height"] = response["links"]["thumbnail"][0]["media"]["height"]
                  flat_hash["thumbnail_width"] = response["links"]["thumbnail"][0]["media"]["width"]
                end
              end
              rescue Exception => e
                render json: {success: false, message: e.to_s}, status: 400
            end
          end
        end

        render json: flat_hash.as_json
      rescue Exception => e
        render json: {success: false, message: e.to_s}, status: 400
      end
    else
      render json: {success: false, message: t('url.required')}, status: 400
    end
  end

  def oembed
    url = "http://13.126.206.16:8000/oembed"
    if params['url'].present?
      begin
        response = RestClient::Request.execute(
          method: "get",
          url: url,
          headers: {
            params: {
              url: utility_params['url'],
            }
          }
        )
        render json: JSON.parse(response)
      rescue  Exception => e
        render json: {success: false, message: e.to_s}, status: 400
      end
    else
      render json: {success: false, message: t('url.required')}, status: 400
    end
  end

  private

  def utility_params
    params.permit(:url)
  end
end
