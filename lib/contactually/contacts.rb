module Contactually
  class Contacts

    def initialize(master)
      @master = master
    end

    def create(params = {})
      raise MissingParameterError, 'Contact hash missing' unless params[:contact]
      @master.call('contacts.json', :post, params)
    end

    def delete(params = {})
      raise MissingParameterError, 'Contact ID missing' unless params[:id]
      @master.call("contacts/#{params[:id]}.json", :delete, {})
    end

    def destroy_multiple(params = {})
      raise MissingParameterError, 'Contact ids missing' unless params[:ids] && params[:ids].class == Array
      @master.call('contacts.json', :delete, params)
    end

    def show(params = {})
      raise MissingParameterError, 'Contact ID missing' unless params[:id]
      @master.call("contacts/#{params[:id]}.json", :get, params_without_id(params))
    end

    def tags(params = {})
      raise MissingParameterError, 'Contact ID missing' unless params[:id]
      raise MissingParameterError, 'Contact tags missing' unless params[:tags] && params[:tags].class == Array
      @master.call("contacts/#{params[:id]}/tags.json", :post, params_without_id(params))
    end

    def update(params = {})
      raise MissingParameterError, 'Contact ID missing' unless params[:id]
      raise MissingParameterError, 'Contact hash missing' unless params[:contact]
      @master.call("contacts/#{params[:id]}.json", :put, params_without_id(params))
    end

    def index(params = {})
      @master.call('contacts.json', :get, params)
    end

    def search(params = {})
      raise MissingParameterError, 'Search term missing' unless params[:term]
      @master.call('contacts/search.json', :get, params)
    end

    private

    def params_without_id(params)
      params.delete_if { |k,v| k == :id }
    end
  end
end
