module Contactually
  class Grouping < OpenStruct
  end

  module Representer
    class GroupingRepresenter < Roar::Decorator
      include Roar::Representer::JSON
      property :id
      property :type
      property :name
      property :stub
      property :user_id
      property :domain_id
      property :editable
      property :conversable
      property :locked
      property :derived_from_id
      property :created_at
      property :updated_at
      property :has_followups
      property :num_days_to_followup
      property :program_id
      property :objective
      property :sort_order
      property :accounts
      property :number_of_contacts
      property :goal
    end
  end
end
