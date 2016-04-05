require 'heroku/conn'
require 'heroku/properties'

module Heroku
  class API
    module RateLimits
      @@etag        = nil
      RESOURCE_TYPE = "RATE_LIMITS"

      def rate_limits
        Heroku::Properties.logger.info("[Rate Limits] Fetching")

        @@etag, res =
          Heroku::Conn::Get(
            "/account/rate-limits",
            etag: @@etag,
            r_type: RESOURCE_TYPE
          )

        res["remaining"].to_i
      end
    end
  end
end
