module Contactually

  class Error < StandardError
  end

  class ConfigMissingApiKeyError < Error
  end

  class InvalidParametersError < Error
  end

  class DuplicatedContactError < Error
  end

  class AuthenticationError < Error
  end

  class APIError < Error
  end

end
