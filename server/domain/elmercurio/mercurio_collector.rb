# frozen_string_literal: true

module Domain
  # Logic to extract many news from El Mercurio provider
  class MercurioCollector
    def initialize(client = Port::WebClient.new)
      @client = client
    end

    def extract
      url = 'https://ww2.elmercurio.com.ec/category/nacionales/'
      links = extract_links(url) + (2..20).map { |num| extract_links "#{url}page/#{num}/" }.flatten # max 500
      links.map do |news_url|
        begin
          news = @client.get_page news_url
          NewsMercurio.new.fill_from news, news_url
        rescue => exception
          puts "#{exception.message} on #{news_url}"
        end
      end.flatten
    end

    private

    def extract_links(url_base)
      page = @client.get_page(url_base)
      page.xpath('//div/div/div/h3/a/@href').map(&:text).compact.uniq
    end
  end
end
