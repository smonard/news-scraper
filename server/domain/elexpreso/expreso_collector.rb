# frozen_string_literal: true

module Domain
  # Logic to extract many news from El Expreso provider
  class ExpresoCollector
    def initialize(client = Port::WebClient.new)
      @client = client
    end

    def extract
      url = 'https://www.expreso.ec/page/busqueda.html?q=Pol%C3%ADtica&settings=%7B%22subcategoryFilter%22%3Afalse%2C%22viewSetting%22%3Afalse%7D&page='
      (1..20).map { |num| extract_by_page "#{url}=#{num}" }.flatten # max 300
    end

    private

    def extract_by_page(url_page)
      page = @client.get_page(url_page)
      page.xpath('//li//div//a/@href').map do |link|
        begin
          news_url = "https://www.expreso.ec#{link.text}"
          news = @client.get_page news_url
          NewsExpreso.new.fill_from news, news_url
        rescue => exception
          puts "#{exception.message} on #{news_url}"
        end
      end.compact
    end
  end
end
