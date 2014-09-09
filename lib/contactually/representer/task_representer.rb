module Contactually
  class Task < OpenStruct
  end

  module Representer
    class TaskRepresenter < Roar::Decorator
      include Roar::Representer::JSON
      property :id
      property :title
      property :due_date
      property :completed_at
      property :deleted_at
      property :is_follow_up
      property :last_contacted
      property :contact_id
      property :ignored
      property :completed_via
      property :approval_data
    end
  end
end
