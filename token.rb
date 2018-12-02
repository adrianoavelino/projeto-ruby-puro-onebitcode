class Token
    def create_token token
        File.open('./.token', 'w') do |line|
            line.puts(token)
        end
    end

    def validate_token token
        begin
            url = 'https://translate.yandex.net/api/v1.5/tr.json/getLangs?ui=en&key=' + token
            json = RestClient.post url, {}
            
        rescue RestClient::ExceptionWithResponse => e
            json = e.response
            e.response
        end
        errorCode = JSON.parse(json)['code']
        
        if(JSON.parse(json)['code'] == 401) 
            false
        else
            true
        end
    end
end
