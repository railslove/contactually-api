module Contactually
  class Tasks
    def initialize(master)
      @master = master
    end

    def show(id, params = {})
      hash = @master.call("tasks/#{id}.json", :get, params)
      Contactually::Utils.build_task(hash)
    end

    def complete(id, params = {})
      hash = @master.call("tasks/#{id}/complete.json", :post, params)
      Contactually::Utils.build_task(hash)
    end

    def create(params = {})
      hash = @master.call('tasks.json', :post, params)
      Contactually::Utils.build_task(hash)
    end

    def destroy(id, params = {})
      @master.call("tasks/#{id}.json", :delete, params)
    end

    def generate_followups(params = {})
      @master.call('tasks/generate_followups.json', :post, params)
    end

    def ignore(id, params = {})
      hash = @master.call("tasks/#{id}/ignore.json", :post, params)
      Contactually::Utils.build_task(hash)
    end

    def index(params = {})
      hash = @master.call('tasks.json', :get, params)
      Contactually::Utils.tasks_hash_to_objects(hash)
    end

    def snooze(id, params = {})
      @master.call("tasks/#{id}/snooze.json", :post, params)
    end

    def update(id, params = {})
      hash = @master.call("tasks/#{id}.json", :put, params)
      Contactually::Utils.build_task(hash)
    end
  end
end
