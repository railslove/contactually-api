module Contactually
  class Content < OpenStruct
  end

  class ContentRepresenter < Roar::Decorator
    include Roar::Representer::JSON
    property :id
    property :user_id
    property :url
    property :title
    property :description
    property :article
    property :original_content_id
    collection :groupings, extend: GroupingRepresenter, class: Grouping
  end

  class Contents
    def initialize(master)
      @master = master
    end

    def create(params = {})
      hash = @master.call('contents.json', :post, params)
      ContentRepresenter.new(Content.new).from_hash(hash)
    end

    def index(params = {})
      hash = @master.call('contents.json', :get, params)
      contents_hash_to_objects(hash)
    end

    def destroy(id, params = {})
      @master.call("contents/#{id}.json", :delete, params)
    end

    def show(id, params = {})
      hash = @master.call("contents/#{id}.json", :get, params)
      ContentRepresenter.new(Content.new).from_hash(hash)
    end

    def update(id, params = {})
      @master.call("contents/#{id}.json", :put, params)
    end

    private

    def contents_hash_to_objects(hash)
      hash['contents'].inject([]) do |arr, content|
        arr << ContentRepresenter.new(Content.new).from_hash(content)
      end
    end
  end
end
