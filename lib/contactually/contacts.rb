module Contactually
  class Contact < OpenStruct
  end

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
    property :groupings
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
  end

  class Contacts
    def initialize(master)
      @master = master
    end

    def create(params = {})
      raise MissingParameterError, 'Contact hash missing' unless params[:contact]
      @master.call('contacts.json', :post, params)
    end

    def delete(params = {})
      raise MissingParameterError, 'Contact ID missing' unless params[:id]
      @master.call("contacts/#{params[:id]}.json", :delete, {})
    end

    def destroy_multiple(params = {})
      raise MissingParameterError, 'Contact ids missing' unless params[:ids] && params[:ids].class == Array
      @master.call('contacts.json', :delete, params)
    end

    def show(params = {})
      raise MissingParameterError, 'Contact ID missing' unless params[:id]
      hash = @master.call("contacts/#{params[:id]}.json", :get, params_without_id(params))
      ContactRepresenter.new(Contact.new).from_json(hash.to_json)
    end

    def tags(params = {})
      raise MissingParameterError, 'Contact ID missing' unless params[:id]
      raise MissingParameterError, 'Contact tags missing' unless params[:tags] && params[:tags].class == Array
      @master.call("contacts/#{params[:id]}/tags.json", :post, params_without_id(params))
    end

    def update(params = {})
      raise MissingParameterError, 'Contact ID missing' unless params[:id]
      raise MissingParameterError, 'Contact hash missing' unless params[:contact]
      @master.call("contacts/#{params[:id]}.json", :put, params_without_id(params))
    end

    def index(params = {})
      hash = @master.call('contacts.json', :get, params)
      contacts_hash_to_objects(hash)
    end

    def search(params = {})
      raise MissingParameterError, 'Search term missing' unless params[:term]
      hash = @master.call('contacts/search.json', :get, params)
      contacts_hash_to_objects(hash)
    end

    private

    def params_without_id(params)
      params.clone.delete_if { |k,v| k == :id }
    end

    def contacts_hash_to_objects(hash)
      res = []
      hash['contacts'].each do |contact|
        res << ContactRepresenter.new(Contact.new).from_json(contact.to_json)
      end
      res
    end
  end
end
