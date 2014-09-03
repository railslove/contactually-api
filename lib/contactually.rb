require 'active_support'
require 'faraday'
require 'json'
require 'roar/decorator'
require 'roar/representer/json'

require 'contactually/version'
require 'contactually/errors'
require 'contactually/api'
require 'contactually/contacts'

module Contactually
  include ActiveSupport::Configurable

  config_accessor(:api_key)
  config_accessor(:contactually_url) { "https://www.contactually.com/api/v1/" }

end
