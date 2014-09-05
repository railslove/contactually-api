module Contactually
  class Contacts
    def initialize(master)
      @master = master
    end

    def create(params = {})
      hash = @master.call('contacts.json', :post, params)
      ContactRepresenter.new(Contact.new).from_hash(hash)
    end

    def destroy(id, params = {})
      @master.call("contacts/#{id}.json", :delete, {})
    end

    def destroy_multiple(params = {})
      @master.call('contacts.json', :delete, params)
    end

    def show(id, params = {})
      hash = @master.call("contacts/#{id}.json", :get, params)
      ContactRepresenter.new(Contact.new).from_hash(hash)
    end

    def merge(params = {})
      hash = @master.call('contacts/merge.json', :post, params)
      ContactRepresenter.new(Contact.new).from_hash(hash)
    end

    def tags(id, params = {})
      params[:tags] = params[:tags].join(', ') if params[:tags].class == Array
      @master.call("contacts/#{id}/tags.json", :post, params)
    end

    def update(id, params = {})
      @master.call("contacts/#{id}.json", :put, params)
    end

    def index(params = {})
      hash = @master.call('contacts.json', :get, params)
      contacts_hash_to_objects(hash)
    end

    def search(params = {})
      hash = @master.call('contacts/search.json', :get, params)
      contacts_hash_to_objects(hash)
    end

    private

    def contacts_hash_to_objects(hash)
      hash['contacts'].inject([]) do |arr, contact|
        arr << ContactRepresenter.new(Contact.new).from_hash(contact)
      end
    end
  end
end
