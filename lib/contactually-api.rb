require 'active_support/configurable'
require 'faraday'
require 'json'
require 'roar/decorator'
require 'roar/representer/json'

require 'contactually/version'
require 'contactually/errors'
require 'contactually/api'
require 'contactually/contacts'
require 'contactually/notes'
require 'contactually/groupings'
require 'contactually/contact_groupings'
require 'contactually/accounts'
require 'contactually/contents'

module Contactually
  include ActiveSupport::Configurable

  config_accessor(:api_key)
  config_accessor(:contactually_url) { "https://www.contactually.com/api/v1/" }
end
