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

    def notes
      Contactually::Notes.new self
    end

    def groupings
      Contactually::Groupings.new self
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

    [ :get, :put, :delete ].each do |method_name|
      define_method("#{method_name}_call") do |url, params|
        response = Faraday.send(method_name, base_url(url), call_params(params))
        JSON.load(response.body)
      end
    end

    def base_url(url)
      "#{@base_url}#{url}"
    end
  end
end
