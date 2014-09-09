module Contactually
  class Contents
    def initialize(master)
      @master = master
    end

    def create(params = {})
      hash = @master.call('contents.json', :post, params)
      Contactually::Utils.build_content(hash)
    end

    def index(params = {})
      hash = @master.call('contents.json', :get, params)
      Contactually::Utils.contents_hash_to_objects(hash)
    end

    def destroy(id, params = {})
      @master.call("contents/#{id}.json", :delete, params)
    end

    def show(id, params = {})
      hash = @master.call("contents/#{id}.json", :get, params)
      Contactually::Utils.build_content(hash)
    end

    def update(id, params = {})
      @master.call("contents/#{id}.json", :put, params)
    end
  end
end
