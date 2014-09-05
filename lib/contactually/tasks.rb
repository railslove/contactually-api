module Contactually
  class Tasks
    def initialize(master)
      @master = master
    end

    def show(id, params = {})
      hash = @master.call("tasks/#{id}.json", :get, params)
      TaskRepresenter.new(Task.new).from_hash(hash)
    end
  end
end
