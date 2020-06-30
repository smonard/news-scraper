# frozen_string_literal: true

module Domain
  # Logic to extract many news from El Universo provider
  class UniversoCollector
    def initialize(client = Port::WebClient.new)
      @client = client
    end

    def extract
      url = 'https://www.eluniverso.com/politica?page'
      (0..7).map { |num| extract_by_page "#{url}=#{num}" }.flatten
    end

    private

    def extract_by_page(url_page)
      page = @client.get_page(url_page)
      page.xpath("//div[@class = 'posts']/div/h2/a/@href").map do |link|
        begin
          news_url = "https://www.eluniverso.com#{link.text}"
          news = @client.get_page news_url
          NewsUniverso.new.fill_from news, news_url
        rescue => exception
          puts "#{exception.message} on #{news_url}"
        end
      end.compact
    end
  end
end
