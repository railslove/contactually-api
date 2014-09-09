module Contactually
  class ContactGroupings
    def initialize(master)
      @master = master
    end

    def create(id, params = {})
      hash = @master.call("contacts/#{id}/groupings.json", :post, params)
      Contactually::Utils.build_grouping(hash)
    end

    def destroy(id, grouping_id, params = {})
      @master.call("contacts/#{id}/groupings/#{grouping_id}.json", :delete, params)
    end
  end
end
