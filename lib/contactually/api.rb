module Contactually
  class API
    def initialize
      raise ConfigMissingApiKeyError, 'You must provide a Contactually API key' unless Contactually.config.api_key
      @api_key = Contactually.config.api_key
      @base_url = Contactually.config.contactually_url
    end

    def call(url, method, params={})
      response = send(method, url, params)
      JSON.load(response.body)
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

    def accounts
      Contactually::Accounts.new self
    end

    def contact_groupings
      Contactually::ContactGroupings.new self
    end

    def connection
      @connection ||= Faraday.new do |faraday|
        faraday.adapter  Faraday.default_adapter
        faraday.headers['Content-Type'] = 'application/json'
        faraday.use Contactually::Middleware::ErrorDetector
      end
    end

    private

    def call_params(params)
      params.merge({ api_key: @api_key })
    end

    def post(url, params)
      response = connection.post do |req|
        req.url base_url(url)
        req.body = call_params(params).to_json
      end
      response
    end

    def put(url, params)
      response = connection.put do |req|
        req.url base_url(url)
        req.body = call_params(params).to_json
      end
      response
    end

    def get(url, params)
      response = connection.get(base_url(url), call_params(params))
      response
    end

    def delete(url, params)
      response = connection.delete(base_url(url), call_params(params))
      response
    end

    def base_url(url)
      "#{@base_url}#{url}"
    end

    end
end
