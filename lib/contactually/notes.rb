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

    private

    def notes_hash_to_objects(hash)
      res = []
      hash['notes'].each do |note|
        res << NoteRepresenter.new(Note.new).from_hash(note)
      end
      res
    end
  end
end
