require 'heroku/conn'
require 'heroku/properties'
require 'heroku/model/app'

module Heroku
  class API
    module App
      @@etags       = {}
      RESOURCE_TYPE = "APP"

      def app(name_or_id)
        Heroku::Properties.logger.info("[App] Fetching #{name_or_id}")

        etag, res =
          Heroku::Conn::Get(
            "/apps/#{name_or_id}",
            etag: @@etags[name_or_id],
            r_type: RESOURCE_TYPE
          )

        @@etags[res['id']]   = etag
        @@etags[res['name']] = etag
        Heroku::Model::App.new(res.merge("parent" => self))
      end

      def new(params = {})
        Heroku::Properties.logger.info("[App] New with parameters: #{params.inspect}")

        _, res =
          Heroku::Conn::Post(
            '/apps',
            r_type: RESOURCE_TYPE,
            body: params.to_json
          )

        Heroku::Model::App.new(res.merge("parent" => self))
      end

      def update_app(app)
        Heroku::Properties.logger.info("[App] Updating #{app.id}")

        etag, res =
          Heroku::Conn::Patch(
            app.end_point,
            r_type: RESOURCE_TYPE,
            body: app.patchable.to_json
          )

        @@etags[res['id']]   = etag
        @@etags[res['name']] = etag
        Heroku::Model::App.new(res.merge("parent" => self))
      end

      def delete_app(app)
        Heroku::Properties.logger.info("[App] Deleting #{app.id}")
        Heroku::Conn::Delete(app.end_point, r_type: RESOURCE_TYPE)
        true
      end
    end
  end
end
