# frozen_string_literal: true

module Domain
  # Logic to extract many news from El Comercio provider
  class ComercioCollector
    def initialize(client = Port::WebClient.new)
      @client = client
    end

    def extract
      url = 'https://www.elcomercio.com/search/Ecuador'
      document = @client.get_page url
      num_pages = document.xpath("//div[@class = 'pagination']/ul/li").map(&:text)[-2].to_i
      extract_by_page(url) + (2..num_pages).map { |num| extract_by_page "#{url}/#{num}" }.flatten
    end

    private

    def extract_by_page(url_page)
      page = @client.get_page(url_page)
      page.xpath("//*[contains(@class, 'article result-news')]/div/div/a/@href").map do |link|
        begin
          news_url = "https://www.elcomercio.com#{link.text}"
          news = @client.get_page news_url
          NewsComercio.new.fill_from news, news_url
        rescue => exception
          puts "#{exception.message} on #{news_url}"
        end
      end.compact
    end
  end
end
