module Contactually
  class Contact < OpenStruct
  end

  module Representer
    class ContactRepresenter < Roar::Decorator
      include Roar::Representer::JSON
      property :id
      property :user_id
      property :first_name
      property :last_name
      property :full_name
      property :initials
      property :title
      property :company
      property :email
      property :avatar
      property :avatar_url
      property :last_contacted
      property :visible
      property :twitter
      property :facebook_url
      property :linkedin_url
      property :first_contacted
      property :created_at
      property :updated_at
      property :hits
      property :team_parent_id
      property :snoozed_at
      property :snooze_days
      property :email_addresses
      property :tags
      property :contact_status
      property :team_last_contacted
      property :team_last_contacted_by
      property :phone_numbers
      property :addresses
      property :social_profiles
      property :websites
      property :custom_fields
      property :sent
      property :received
      property :link
      property :content
      collection :groupings, extend: GroupingRepresenter, class: Grouping
    end
  end
end
