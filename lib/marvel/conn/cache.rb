require 'marvel/properties'

class Marvel::Conn::Cache
  CachePair = Struct.new(:response, :etag)

  def initialize()
    @response_cache = {}
    @etag_pointers  = {}
  end

  def put(r_type, new_etag, json)
    pair        = pair(r_type)
    key         = key(json)
    old_etag, _ = pair.response[key]
    record      = [new_etag, json]

    Marvel::Properties.logger.debug("[#{r_type} Cache] Caching #{key}    #{new_etag}")
    Marvel::Properties.logger.debug("[#{r_type} Cache] Dissociating tag: #{old_etag}")

    pair.etag.delete(old_etag)
    pair.response[key]  = record
    pair.etag[new_etag] = record
    record
  end

  def fetch(r_type, etag)
    Marvel::Properties.logger.info("[#{r_type} Cache] Fetching #{etag}")
    pair(r_type).etag[etag]
  end

private

  def pair(r_type)
    CachePair[
      @response_cache[r_type] ||= {},
      @etag_pointers[r_type]  ||= {}
    ]
  end

  def key(json_response)
    case json_response
    when Array then "list"
    when Hash  then json_response['id']
    else            nil
    end
  end
end
