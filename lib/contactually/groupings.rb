module Contactually
  class Grouping < OpenStruct
  end

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

  class GroupingStatistics < OpenStruct
  end

  class GroupingStatisticsRepresenter < Roar::Decorator
    include Roar::Representer::JSON
    property :messages_sent
    property :messages_received
    property :status
    collection :contacts, extend: ContactRepresenter, class: Contact
  end

  class Groupings
    def initialize(master)
      @master = master
    end

    def create(params = {})
      hash = @master.call('groupings.json', :post, params)
      GroupingRepresenter.new(Grouping.new).from_hash(hash)
    end

    def index(params = {})
      hash = @master.call('groupings.json', :get, params)
      groupings_hash_to_objects(hash)
    end

    def minimal_index(params = {})
      hash = @master.call('groupings/minimal_index.json', :get, params)
      GroupingRepresenter.new(Grouping.new).from_hash(hash)
    end

    def destroy(id, params = {})
      @master.call("groupings/#{id}.json", :delete, params)
    end

    def show(id, params = {})
      hash = @master.call("groupings/#{id}.json", :get, params)
      GroupingRepresenter.new(Grouping.new).from_hash(hash)
    end

    def update(id, params = {})
      hash = @master.call("groupings/#{id}.json", :put, params)
      GroupingRepresenter.new(Grouping.new).from_hash(hash)
    end

    def statistics(id, params = {})
      hash = @master.call("groupings/#{id}/statistics.json", :get, params)
      GroupingStatisticsRepresenter.new(GroupingStatistics.new).from_hash(hash)
    end

    private

    def groupings_hash_to_objects(hash)
      hash['groupings'].inject([]) do |arr, grouping|
        arr << GroupingRepresenter.new(Grouping.new).from_hash(grouping)
      end
    end
  end
end
