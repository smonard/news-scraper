# frozen_string_literal: true

module Domain
  # Logic to extract many news from Vistazo provider
  class VistazoCollector
    def initialize(client = Port::WebClient.new)
      @client = client
    end

    def extract
      url = 'https://www.vistazo.com/seccion/politica?page='
      news_links = infer_urls url
      extract_news news_links
    end

    private

    def infer_urls(url)
      (0..10).map do |num| # max 340
        page = @client.get_page "#{url}#{num}"
        page.xpath("//div[@class = 'panel-panel panel-col']//h3/a/@href").map(&:text)
      end.flatten.uniq
    end

    def extract_news(news_links)
      server = 'https://www.vistazo.com'
      news_links.filter { |link| link.include? 'pais/politica-nacional' }.map do |page_link|
        begin
          news_url = "#{server}#{page_link}"
          news = @client.get_page news_url
          NewsVistazo.new.fill_from news, news_url
        rescue => exception
          puts "#{exception.message} on #{news_url}"
        end
      end.compact
    end
  end
end
