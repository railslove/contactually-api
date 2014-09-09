module Contactually
  class Account < OpenStruct
  end

  module Representer
    class AccountRepresenter < Roar::Decorator
      include Roar::Representer::JSON
      property :id
      property :username
      property :remote_id
      property :type
      property :disabled_at
    end
  end
end
