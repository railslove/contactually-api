module Contactually
  class Accounts

    def initialize(master)
      @master = master
    end

    def index(params = {})
      hash = @master.call('accounts.json', :get, params)
      accounts_hash_to_objects(hash)
    end

    def show(id, params = {})
      hash = @master.call("accounts/#{id}.json", :get, params)
      AccountRepresenter.new(Account.new).from_hash(hash)
    end

    def destroy(id, params = {})
      @master.call("accounts/#{id}.json", :delete, params)
    end

    private

    def accounts_hash_to_objects(hash)
      hash['accounts'].inject([]) do |arr, account|
        arr << AccountRepresenter.new(Account.new).from_hash(account)
      end
    end

  end
end
