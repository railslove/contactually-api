module Contactually

  class Error < StandardError
  end

  class ConfigMissingApiKeyError < Error
  end

  class MissingParameterError < Error
  end

end
