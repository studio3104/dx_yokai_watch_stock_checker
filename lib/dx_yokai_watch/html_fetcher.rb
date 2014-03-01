require 'net/http'
require 'uri'
require 'nokogiri'

module DXYokaiWatch
  class HTMLFetcher
    attr_reader :uri

    def initialize(url)
      @uri = URI.parse(url)
    end

    def parsed_html
      Nokogiri::HTML.parse(html_body())
    end

    def html_body(uri = @uri)
      request_path = uri.query ? uri.path + '?' + uri.query : uri.path
      begin
        response = http.start { |http| http.get(request_path) }
      rescue IOError, EOFError, Errno::ECONNRESET, Errno::ETIMEDOUT, SystemCallError
        return 'unko' # toriaezu
      end

      response.body
    end

    def http
      http = Net::HTTP.new(@uri.host, @uri.port)
      http.open_timeout = 3
      http.read_timeout = 3
      http
    end
  end
end
