module Contactually
  class Accounts

    def initialize(master)
      @master = master
    end

    def index(params = {})
      hash = @master.call('accounts.json', :get, params)
      Contactually::Utils.accounts_hash_to_objects(hash)
    end

    def show(id, params = {})
      hash = @master.call("accounts/#{id}.json", :get, params)
      Contactually::Utils.build_account(hash)
    end

    def destroy(id, params = {})
      @master.call("accounts/#{id}.json", :delete, params)
    end
  end
end
