require 'heroku/conn'
require 'heroku/properties'
require 'heroku/model/account'

module Heroku
  class API
    module Account
      @@etag        = nil
      RESOURCE_TYPE = "ACCOUNT"

      def account
        Heroku::Properties.logger.info("[Account] Fetching.")

        @@etag, res =
          Heroku::Conn::Get(
            '/account',
            etag: @@etag,
            r_type: RESOURCE_TYPE
          )

        Heroku::Model::Account.new(res.merge("parent" => self))
      end

      def update_account(account)
        Heroku::Properties.logger.info("[Account] Updating #{account.id}")

        @@etag, res =
          Heroku::Conn::Patch(
            "/account",
            r_type: RESOURCE_TYPE,
            body: account.patchable.to_json
          )

        Heroku::Model::Account.new(res.merge("parent" => self))
      end
    end
  end
end
