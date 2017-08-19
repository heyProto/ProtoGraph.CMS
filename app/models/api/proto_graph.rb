class Api::ProtoGraph
    class Datacast
        class << self

            def create(request_payload)
                url = "#{AWS_API_DATACAST_URL}/datacast"
                response = RestClient.post(url , request_payload.to_json,{content_type: :json, accept: :json, "x-api-key" => ENV['AWS_API_KEY']})
                return JSON.parse(response.body)
            end


            def update(request_payload)
                url = "#{AWS_API_DATACAST_URL}/datacast"
                response = RestClient.put(url , request_payload.to_json,{content_type: :json, accept: :json, "x-api-key" => ENV['AWS_API_KEY']})
                return JSON.parse(response.body)
            end

            def delete(request_payload)
                url = "#{AWS_API_DATACAST_URL}/datacast"
                response = RestClient::Request.execute(method: :delete, url: url ,payload: request_payload.to_json,headers: {content_type: "application/json", accept: "applciation/json", "x-api-key" => ENV['AWS_API_KEY']})
                return JSON.parse(response.body)
            end
        end
    end

    class ViewCast
        class << self

            def render_screenshot(request_payload)
                url = "#{AWS_API_DATACAST_URL}/view-cast/render-screenshot"
                response = RestClient.post(url , request_payload.to_json,{content_type: :json, accept: :json, "x-api-key" => ENV['AWS_API_KEY']})
                return JSON.parse(response.body)
            end
        end
    end


    class Utility

        class << self
            def upload_to_cdn(binary_file, key, content_type)
                url = "#{AWS_API_DATACAST_URL}/utility/upload-to-cdn"
                response = RestClient.post(url , {binary_file: binary_file, key: key, content_type: content_type}.to_json,{content_type: :json, accept: :json, "x-api-key": ENV['AWS_API_KEY']})
                return JSON.parse(response.body)
            end

            def remove_from_cdn(file_url)
                url = "#{AWS_API_DATACAST_URL}/utility/delete-from-cdn"
                params = {"file_url": file_url}.to_json
                response = RestClient::Request.execute(method: :delete, url: url, headers: {content_type: :json,accept: :json ,"x-api-key" => ENV['AWS_API_KEY']}, payload: params)
                return true
            end
        end
    end

    class CloudFront

        class << self

            def invalidate(items, quantity)
                url = "#{AWS_API_DATACAST_URL}/cloudfront/invalidate"
                params = {"invalidation_items": items, quantity: quantity, distribution_id: ENV['AWS_CDN_ID']}.to_json
                response = RestClient.post(url , params,{content_type: :json, accept: :json, "x-api-key": ENV['AWS_API_KEY']})
                return JSON.parse(response.body)
            end
        end

    end
end