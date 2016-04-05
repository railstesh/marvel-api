require 'heroku/conn'
require 'heroku/properties'

module Heroku
  class API
    module Password
      def update_password(new_password, current_password)
        Heroku::Properties.logger.info("[Password] Updating")

        Heroku::Conn::Put("/account/password", body: {
          password:             new_password,
          current_password: current_password
        }.to_json)
        true
      end
    end
  end
end
