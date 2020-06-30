# frozen_string_literal: true

require 'net/http'
require 'nokogiri'

module Port
  # Web client for web pages retrieval
  class WebClient
    def get_page(url)
      uri = URI.parse(url)
      http = Net::HTTP.new(uri.host, uri.port)
      http.open_timeout, http.read_timeout = 90, 120 
      http.use_ssl = true
      Nokogiri::HTML.parse(http.get(uri.request_uri).body)
    end
  end
end
