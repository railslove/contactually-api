module Contactually
  class GroupingStatistic < OpenStruct
  end

  module Representer
    class GroupingStatisticRepresenter < Roar::Decorator
      include Roar::Representer::JSON
      property :messages_sent
      property :messages_received
      property :status
      collection :contacts, extend: ContactRepresenter, class: Contact
    end
  end
end
