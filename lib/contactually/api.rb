module Contactually
  class API
    def initialize
      raise ConfigMissingApiKeyError, 'You must provide a Contactually API key' unless Contactually.config.api_key
      @api_key = Contactually.config.api_key
      @base_url = Contactually.config.contactually_url
    end

    def call(url, method, params={})
      send("#{method.to_s}_call", url, params)
    end

    def contacts
      Contactually::Contacts.new self
    end

    private

    def call_params(params)
      params.merge({ api_key: @api_key })
    end

    def post_call(url, params)
      response = Faraday.post do |req|
        req.url base_url(url)
        req.headers['Content-Type'] = 'application/json'
        req.body = call_params(params)
      end
      JSON.load(response.body)
    end

    def get_call(url, params)
      response = Faraday.get base_url(url), call_params(params)
      JSON.load(response.body)
    end

    def put_call(url, params)
      response = Faraday.put base_url(url), params
      JSON.load(response.body)
    end

    def delete_call(url, params)
      response = Faraday.delete base_url(url), params
      JSON.load(response.body)
    end

    def base_url(url)
      "#{@base_url}#{url}"
    end
  end
end
