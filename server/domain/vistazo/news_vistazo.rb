# frozen_string_literal: true

module Domain
  # Parses a news from an HTML document
  class NewsVistazo
    def fill_from(document, url)
      @title = document.xpath("//div[@class = 'pane-content']/h1").text
      @datetime = document.xpath("//div[@class = 'intefecha']/span")[-1].text
      expression = "//div[@class = 'panel-pane pane-node-body']//span"
      @content = document.xpath(expression).map(&:text).map(&:strip).reject(&:empty?).join "\n"
      @url = url
      @provider = 'Vistazo'
      self
    end

    def to_json(_ = nil)
      { title: @title, datetime: @datetime, content: @content, url: @url, provider: @provider }.to_json
    end
  end
end
