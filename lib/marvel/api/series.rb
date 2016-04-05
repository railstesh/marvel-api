require 'marvel/conn'
require 'marvel/properties'


module Marvel
  class API
    module Series
      @@etags       = {}
      RESOURCE_TYPE = "SERIES"
      API_BASE_PATH = "/v1/public/series"

      def getSeries(params = {})
        Marvel::Properties.logger.info("[#{RESOURCE_TYPE}] Fetching #{params}")
        baseRequest("#{API_BASE_PATH}", params)
      end

      def getSeries(id, params = {})
        Marvel::Properties.logger.info("[#{RESOURCE_TYPE}:#{id}] Fetching #{params}")
        baseRequest("#{API_BASE_PATH}/#{id}", params)
      end

      def getCharactersOfSeries(id, params = {})
        resource = "characters"
        Marvel::Properties.logger.info("[#{RESOURCE_TYPE}:#{id}] with #{resource} Fetching #{params}")
        baseRequest("/#{API_BASE_PATH}/#{id}/#{resource}", params)
      end
      
      def getComicsOfSeries(id, params = {})
        resource = "comics"
        Marvel::Properties.logger.info("[#{RESOURCE_TYPE}:#{id}] with #{resource} Fetching #{params}")
        baseRequest("/#{API_BASE_PATH}/#{id}/#{resource}", params)
      end

      def getCreatorsOfSeries(id, params = {})
        resource = "creators"
        Marvel::Properties.logger.info("[#{RESOURCE_TYPE}:#{id}] with #{resource} Fetching #{params}")
        baseRequest("#{API_BASE_PATH}/#{id}/#{resource}", params)
      end

      def getEventsOfSeries(id, params = {})
        resource = "events"
        Marvel::Properties.logger.info("[#{RESOURCE_TYPE}:#{id}] with #{resource} Fetching #{params}")
        baseRequest("#{API_BASE_PATH}/#{id}/#{resource}", params)
      end

      def getStoriesOfSeries(id, params = {})
        resource = "stories"
        Marvel::Properties.logger.info("[#{RESOURCE_TYPE}:#{id}] with #{resource} Fetching #{params}")
        baseRequest("#{API_BASE_PATH}/#{id}/#{resource}", params)
      end


  private
      def baseRequest(path, params = {})
        etag, res =
          Marvel::Conn::Get(
            "#{path}#{Marvel::Conn.authorization_params}",
            etag: @@etags["path"],
            r_type: RESOURCE_TYPE
          )
        responce_handlar(res)  
        @@etags[res['id']]   = etag
        @@etags[res['name']] = etag
        ##Heroku::Model::App.new(res.merge("parent" => self))
      end

      def responce_handlar(responce_obj)
        characters_count = responce_obj['data']['total']
        characters_info = responce_obj['data']['results'].collect{|res| {name:res['name'], thumbnail:res['thumbnail']} }
        puts "characters count : " + characters_count.to_s
        puts characters_info
      end     
    end
  end
end
