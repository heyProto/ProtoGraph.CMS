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

    class Utility

        class << self
            def upload_to_cdn(binary_file, key, content_type, bucket_name)
                url = "#{AWS_API_DATACAST_URL}/utility/upload-to-cdn"
                response = RestClient.post(url , {binary_file: binary_file, key: key, content_type: content_type, bucket_name: bucket_name}.to_json,{content_type: :json, accept: :json, "x-api-key": ENV['AWS_API_KEY']})
                return JSON.parse(response.body)
            end

            def remove_from_cdn(file_url, bucket_name)
                url = "#{AWS_API_DATACAST_URL}/utility/delete-from-cdn"
                params = {"file_url": file_url, "bucket_name": bucket_name}.to_json
                response = RestClient::Request.execute(method: :delete, url: url, headers: {content_type: :json,accept: :json ,"x-api-key" => ENV['AWS_API_KEY']}, payload: params)
                return true
            end
        end
    end

    class CloudFront

        class << self

            def invalidate(site=nil, items, quantity)
                return [] if Rails.env.development?
                url = "#{AWS_API_DATACAST_URL}/cloudfront/invalidate"
                if site.present?
                    params = {}
                    # if site.cdn_provider == "CloudFront"
                        params[:source] = site.cdn_provider
                        params[:quantity] = quantity
                        params[:distribution_id] = site.cdn_id
                        creds = {'aws_access_key_id': site.client_token, 'aws_secret_access_key': site.client_secret}
                        params[:credentials] = creds
                        params[:invalidation_items] = items
                    # else
                    #     params[:source] = "Akamai"
                    #     creds = {}
                    #     creds[:host] = site.host
                    #     creds[:client_secret] = site.client_secret
                    #     creds[:client_token] = site.client_token
                    #     creds[:access_token] = site.access_token
                    #     params[:credentials] = creds
                    #     invalidation_items = []
                    #     items.each do |item|
                    #         invalidation_items << "#{site.cdn_endpoint}#{item}"
                    #     end
                    #     params["invalidation_items"] = invalidation_items
                    # end
                else
                    params = {"invalidation_items": items, quantity: quantity, distribution_id: ENV['AWS_CDN_ID'], source: "CloudFront", credentials: {'aws_access_key_id': ENV['AWS_ACCESS_KEY_ID'], 'aws_secret_access_key': ENV['AWS_SECRET_ACCESS_KEY']}}
                end
                unless ENV['SKIP_INVALIDATION'] == "true"
                    response = RestClient.post(url , params.to_json,{content_type: :json, accept: :json, "x-api-key": ENV['AWS_API_KEY']})
                    return JSON.parse(response.body)
                else
                    return []
                end
            end
        end

    end

    class Page
        class << self
            def create_or_update_page(page_s3, template_page_s3, bucket_name, aws_s3_endpoint)
                url = "#{AWS_API_DATACAST_URL}/pages"
                response = RestClient.post(url , {
                    page_s3: page_s3,
                    template_page_s3: template_page_s3,
                    bucket_name: bucket_name,
                    aws_s3_endpoint: aws_s3_endpoint
                }.to_json, {
                    content_type: :json,
                    accept: :json,
                    "x-api-key": ENV['AWS_API_KEY']
                })
                return JSON.parse(response.body)
            end
        end
    end

    class Site
        class << self
            def create_bucket_and_distribution(bucket_name)
                url = "#{AWS_API_DATACAST_URL}/sites"
                response = RestClient.post(url , {
                    bucket_name: bucket_name
                }.to_json, {
                    content_type: :json,
                    accept: :json,
                    "x-api-key": ENV['AWS_API_KEY']
                })
                return JSON.parse(response.body)
            end
        end
    end
end