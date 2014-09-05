module Contactually
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
