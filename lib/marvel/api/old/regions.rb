require 'heroku/conn'
require 'heroku/properties'

module Heroku
  class API
    module Regions
      def regions
        Heroku::Properties.logger.info("[Regions] Fetching")
        Heroku::Conn::Get("/regions").last
      end
    end
  end
end
