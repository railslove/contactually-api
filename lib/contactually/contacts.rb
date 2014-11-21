module Contactually
  class Contacts
    def initialize(master)
      @master = master
    end

    def create(params = {})
      hash = @master.call('contacts.json', :post, params)
      Contactually::Utils.build_contact(hash)
    end

    def destroy(id, params = {})
      @master.call("contacts/#{id}.json", :delete, {})
    end

    def destroy_multiple(params = {})
      @master.call('contacts.json', :delete, params)
    end

    def show(id, params = {})
      hash = @master.call("contacts/#{id}.json", :get, params)
      Contactually::Utils.build_contact(hash)
    end

    def merge(params = {})
      hash = @master.call('contacts/merge.json', :post, params)
      Contactually::Utils.build_contact(hash)
    end

    def tags(id, params = {})
      params[:tags] = params[:tags].join(', ') if params[:tags].class == Array
      @master.call("contacts/#{id}/tags.json", :post, params)
    end

    def update(id, params = {})
      hash = @master.call("contacts/#{id}.json", :put, params)
      Contactually::Utils.build_contact(hash);
    end

    def index(params = {})
      hash = @master.call('contacts.json', :get, params)
      Contactually::Utils.contacts_hash_to_objects(hash)
    end

    def search(params = {})
      hash = @master.call('contacts/search.json', :get, params)
      Contactually::Utils.contacts_hash_to_objects(hash)
    end

    def count(params = { limit: 1 })
      @master.call('contacts.json', :get, params)["total_count"]
    end
  end
end
