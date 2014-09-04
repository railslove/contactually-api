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

    def show(params = {})
      raise MissingParameterError, 'Note ID missing' unless params[:id]
      hash = @master.call("notes/#{params[:id]}.json", :get, params_without_id(params))
      NoteRepresenter.new(Note.new).from_hash(hash)
    end

    def create(params = {})
      raise MissingParameterError, 'Note Hash missing' unless params[:note]
      hash = @master.call('notes.json', :post, params)
      NoteRepresenter.new(Note.new).from_hash(hash)
    end

    def destroy(params = {})
      raise MissingParameterError, 'Note ID missing' unless params[:id]
      @master.call("notes/#{params[:id]}.json", :delete, params_without_id(params))
    end

    private

    def params_without_id(params)
      params.clone.delete_if { |k,v| k == :id }
    end

    def notes_hash_to_objects(hash)
      hash['notes'].inject([]) do |arr, note|
        arr << NoteRepresenter.new(Note.new).from_hash(note)
      end
    end
  end
end
