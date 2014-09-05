module Contactually
  class GroupingStatistics < OpenStruct
  end

  class GroupingStatisticsRepresenter < Roar::Decorator
    include Roar::Representer::JSON
    property :messages_sent
    property :messages_received
    property :status
    collection :contacts, extend: ContactRepresenter, class: Contact
  end
end
