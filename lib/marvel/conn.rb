require 'json'
require 'net/http'
require 'digest/md5'
require 'marvel/properties'

module Marvel
  class Conn
    require 'marvel/conn/cache'

    APIRequest = Struct.new(:method, :end_point)

    @https = Net::HTTP.new('gateway.marvel.com', 80).tap do |https|
      https.use_ssl = false
    end

    def self.cache
      @cache ||= Marvel::Conn::Cache.new
    end

    def self.method_missing(method, end_point, opts = {})
      _Request = Net::HTTP.const_get(method.capitalize)

      req      = _Request.new(end_point, headers(opts))
      req.body = opts[:body]
      api_req  = APIRequest[method, end_point]

      Marvel::Properties.logger.debug("[Conn] Attempting #{method.upcase} #{end_point} ...")

      check_response(api_req, opts[:r_type], @https.request(req))
    end

  private

    def self.check_response(api_req, r_type, res)
      Marvel::Properties.logger.debug("[Conn] Received #{res.code} for #{r_type} at #{api_req.end_point}")

      case res
      when Net::HTTPOK,
           Net::HTTPCreated
        cache.put(
          r_type, res["ETag"],
          parse_body(res)
        )
      when Net::HTTPPartialContent
        cache.put(
          r_type, res["ETag"],
          gather_partial_content(api_req, res)
        )
      when Net::HTTPNotModified then cache.fetch(r_type, res["ETag"])
      when Net::HTTPSuccess     then [res["ETag"], parse_body(res)]
      else                           raise_exception(res)
      end
    end

    def gather_partial_content(api_req, res)
      Marvel::Properties.logger.info("[Conn] Gathering Partial Content.")

      list_head = parse_body(res)
      etag, list_tail =
        self.send(
          api_req.method,
          api_req.end_point,
          range: res["Next-Range"]
        )

      list_tail.unshift(*list_head)
    end

    def self.raise_exception(res)
      Marvel::Properties.logger.error("[Conn response] #{res.body.inspect}")
      Marvel::Properties.logger.error("[Conn] Uh oh, something went wrong with request #{res["Request-Id"]}.")
      raise res.class::EXCEPTION_TYPE.new(status(res.code), nil)
    end

    def self.status(code)
      Hash[Net::HTTPResponse::CODE_TO_OBJ.map { |k, v| [k, v.to_s] }]
        .merge({ "429" => "Net::HTTPTooManyRequests" })
        .fetch(code, "Net::HTTPUnknownError")
    end

    def self.headers(opts = {})
      {
        "Accept"        => 'application/json',
        "Content-Type"  => 'application/json;charset=utf-8',
        "User-Agent"    => Marvel::Properties::USER_AGENT
      }.merge({}.tap do |header|
        header["If-None-Match"] = opts[:etag]  if opts[:etag]
        header["Range"]         = opts[:range] if opts[:range]
      end)
    end

  	def self.authorization_params
		ts = Time.now.to_i
		hash = Digest::MD5.hexdigest("#{ts}#{Marvel::Properties.private_key}#{Marvel::Properties.public_key}")
		"?ts=#{ts}&apikey=#{Marvel::Properties.public_key}&hash=#{hash}"
  	end

    def self.parse_body(res)
      JSON.parse(decompress(res))
    end

    def self.decompress(res)
      case res["content-encoding"]
      when 'gzip'
        Zlib::GzipReader.new(
          StringIO.new(res.body),
          encoding: "ASCII-8BIT"
        ).read
      when 'deflate'
        Zlib::Inflate.inflate(res.body)
      else
        res.body
      end
    end
  end
end
