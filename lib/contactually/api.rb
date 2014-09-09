module Contactually
  class API
    def initialize
      raise ConfigMissingApiKeyError, 'You must provide a Contactually API key' unless Contactually.config.api_key
      @api_key = Contactually.config.api_key
      @base_url = Contactually.config.contactually_url
    end

    def call(url, method, params={})
      JSON.load(send(method, url, params))
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

    [ :post, :put ].each do |method_name|
      define_method(method_name) do |url, params|
        response = connection.send(method_name) do |req|
          req.url base_url(url)
          req.body = call_params(params).to_json
        end
        response.body
      end
    end

    [ :get, :delete ].each do |method_name|
      define_method(method_name) do |url, params|
        response = connection.send(method_name, base_url(url), call_params(params))
        response.body
      end
    end

    def base_url(url)
      "#{@base_url}#{url}"
    end

    end
end
