module Contactually
  class API
    def initialize
      raise ConfigMissingApiKeyError, 'You must provide a Contactually API key' unless Contactually.config.api_key
      @api_key = Contactually.config.api_key
      @base_url = Contactually.config.contactually_url
    end

    def call(url, http_method, params={})
      response = send(http_method, url, params)
      JSON.load(response.body)
    end

    def contacts
      @contacts ||= Contactually::Contacts.new self
    end

    def notes
      @notes ||= Contactually::Notes.new self
    end

    def tasks
      @tasks ||= Contactually::Tasks.new self
    end

    def groupings
      @groupings ||= Contactually::Groupings.new self
    end

    def accounts
      @accounts ||= Contactually::Accounts.new self
    end

    def contact_groupings
      @contact_groupings ||= Contactually::ContactGroupings.new self
    end

    def contents
      @contents ||= Contactually::Contents.new self
    end

    def connection
      @connection ||= Faraday.new do |faraday|
        faraday.adapter Faraday.default_adapter
        faraday.headers['Content-Type'] = 'application/json'
        faraday.use Contactually::Middleware::ErrorDetector
      end
    end

  private

    def call_params(params)
      params.merge({ api_key: @api_key })
    end

    def post(url, params)
      connection.post do |req|
        req.url base_url(url)
        req.body = call_params(params).to_json
      end
    end

    def put(url, params)
      connection.put do |req|
        req.url base_url(url)
        req.body = call_params(params).to_json
      end
    end

    def get(url, params)
      connection.get(base_url(url), call_params(params))
    end

    def delete(url, params)
      connection.delete(base_url(url), call_params(params))
    end

    def base_url(url)
      "#{@base_url}#{url}"
    end
  end
end
