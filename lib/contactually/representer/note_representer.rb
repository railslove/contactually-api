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
end
