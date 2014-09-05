module Contactually
  class Note < OpenStruct
  end

  class NoteRepresenter < Roar::Decorator
    include Roar::Representer::JSON
    property :id
    property :body
    property :contact_id
    property :timestamp
    property :user_id
  end

  class Notes
    def initialize(master)
      @master = master
    end

    def index(params = {})
      hash = @master.call('notes.json', :get, params)
      notes_hash_to_objects(hash)
    end

    def show(id, params = {})
      hash = @master.call("notes/#{id}.json", :get, params)
      NoteRepresenter.new(Note.new).from_hash(hash)
    end

    def create(params = {})
      hash = @master.call('notes.json', :post, params)
      NoteRepresenter.new(Note.new).from_hash(hash)
    end

    def destroy(id, params = {})
      @master.call("notes/#{id}.json", :delete, params)
    end

    def update(id, params = {})
      hash = @master.call("notes/#{id}.json", :put, params)
      NoteRepresenter.new(Note.new).from_hash(hash)
    end

    private

    def notes_hash_to_objects(hash)
      hash['notes'].inject([]) do |arr, note|
        arr << NoteRepresenter.new(Note.new).from_hash(note)
      end
    end
  end
end
