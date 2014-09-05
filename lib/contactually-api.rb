require 'active_support/configurable'
require 'faraday'
require 'json'
require 'roar/decorator'
require 'roar/representer/json'

require 'contactually/version'
require 'contactually/errors'

require 'contactually/representer/grouping_representer'
require 'contactually/representer/account_representer'
require 'contactually/representer/contact_representer'
require 'contactually/representer/content_representer'
require 'contactually/representer/grouping_statistics_representer'
require 'contactually/representer/note_representer'
require 'contactually/representer/task_representer'

require 'contactually/api'
require 'contactually/groupings'
require 'contactually/contacts'
require 'contactually/notes'
require 'contactually/contact_groupings'
require 'contactually/accounts'
require 'contactually/contents'
require 'contactually/tasks'

module Contactually
  include ActiveSupport::Configurable

  config_accessor(:api_key)
  config_accessor(:contactually_url) { "https://www.contactually.com/api/v1/" }
end
