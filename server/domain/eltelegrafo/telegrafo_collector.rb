# frozen_string_literal: true

module Domain
  # Logic to extract many news from El Telegrafo provider
  class TelegrafoCollector
    def initialize(client = Port::WebClient.new)
      @client = client
    end

    def extract
      url = 'https://www.eltelegrafo.com.ec/contenido/categoria/1/politica?start='
      (0..40).map { |num| extract_by_page "#{url}=#{num}" }.flatten # max 22152
    end

    private

    def extract_by_page(url_page)
      page = @client.get_page(url_page)
      page.xpath('//div/h2/a/@href').map do |link|
        begin
          news_url = "https://www.eltelegrafo.com.ec#{link.text}"
          news = @client.get_page news_url
          NewsTelegrafo.new.fill_from news, news_url
        rescue => exception
          puts "#{exception.message} on #{news_url}"
        end
      end.compact
    end
  end
end
