# frozen_string_literal: true

module Domain
  # Parses a news from an HTML document (El Comercio)
  class NewsComercio
    def fill_from(document, url)
      @title = document.xpath("//div[@class = 'title']").text
      @datetime = document.xpath("//div[@class = 'date']").text
      @content = document.xpath("//div[@class = 'paragraphs']/p")
                         .map(&:text).map(&:strip).reject(&:empty?).join "\n"
      @url = url
      @provider = 'El Comercio'
      self
    end

    def to_json(_ = nil)
      { title: @title, datetime: @datetime, content: @content, url: @url, provider: @provider }.to_json
    end
  end
end
