class Api::Haiku
    class Utility

        class << self
            def upload_to_cdn(binary_file, key, content_type)
                url = "#{AWS_API_URL}/utility/upload-to-cdn"
                response = RestClient.post(url , {binary_file: binary_file, key: key, content_type: content_type}.to_json,{content_type: :json, accept: :json})
                return JSON.parse(response.body)
            end

            def remove_from_cdn(file_url)
            end
        end
    end
end