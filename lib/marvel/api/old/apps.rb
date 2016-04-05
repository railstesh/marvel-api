require 'heroku/conn'
require 'heroku/properties'
require 'heroku/model/app_list'
require 'heroku/model/app'

module Heroku
  class API
    module Apps
      @@etag        = nil
      RESOURCE_TYPE = "APPS"

      def apps
        Heroku::Model::AppList.new( ->(parent){
          Heroku::Properties.logger.info("[Apps] Fetching")

          @@etag, res =
            Heroku::Conn::Get(
              "/apps",
              etag: @@etag,
              r_type: RESOURCE_TYPE
            )

          res.map do |params|
            Heroku::Model::App.new(params.merge("parent" => parent))
          end
        })
      end

    end
  end
end
