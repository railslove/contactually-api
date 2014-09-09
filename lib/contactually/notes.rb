module Contactually
  class Notes
    def initialize(master)
      @master = master
    end

    def index(params = {})
      hash = @master.call('notes.json', :get, params)
      Contactually::Utils.notes_hash_to_objects(hash)
    end

    def show(id, params = {})
      hash = @master.call("notes/#{id}.json", :get, params)
      Contactually::Utils.build_note(hash)
    end

    def create(params = {})
      hash = @master.call('notes.json', :post, params)
      Contactually::Utils.build_note(hash)
    end

    def destroy(id, params = {})
      @master.call("notes/#{id}.json", :delete, params)
    end

    def update(id, params = {})
      hash = @master.call("notes/#{id}.json", :put, params)
      Contactually::Utils.build_note(hash)
    end
  end
end
