module Contactually
  class Groupings
    def initialize(master)
      @master = master
    end

    def create(params = {})
      hash = @master.call('groupings.json', :post, params)
      Contactually::Utils.build_grouping(hash)
    end

    def index(params = {})
      hash = @master.call('groupings.json', :get, params)
      Contactually::Utils.groupings_hash_to_objects(hash)
    end

    def minimal_index(params = {})
      hash = @master.call('groupings/minimal_index.json', :get, params)
      Contactually::Utils.build_grouping(hash)
    end

    def destroy(id, params = {})
      @master.call("groupings/#{id}.json", :delete, params)
    end

    def show(id, params = {})
      hash = @master.call("groupings/#{id}.json", :get, params)
      Contactually::Utils.build_grouping(hash)
    end

    def update(id, params = {})
      hash = @master.call("groupings/#{id}.json", :put, params)
      Contactually::Utils.build_grouping(hash)
    end
  end
end
