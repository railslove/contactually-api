module Contactually
  class Content < OpenStruct
  end

  module Representer
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
  end
end
