require 'marvel/version'

module Marvel
  class Properties
    require 'marvel/properties/null_logger'

    USER_AGENT    = "Marvel API Gem #{Marvel::VERSION}"
    @@public_key  = nil
    @@private_key = nil
    @@logger      = nil

    def self.public_key
      @@public_key
    end

    def self.private_key
      @@private_key
    end

    def self.public_key=(key)
      raise ArgumentError, "Need an API Public Key" if key.nil?
      @@public_key = key
      key
    end

    def self.private_key=(key)
      raise ArgumentError, "Need an API Private_key Key" if key.nil?
      @@private_key = key
      key
    end

    def self.logger
      @@logger || NullLogger.new
    end

    def self.logger=(logger)
      @@logger = logger
    end

    module ConfigMethods
      def configure # yield
        yield Marvel::Properties
      end
    end
  end
end
