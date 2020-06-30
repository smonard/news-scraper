# frozen_string_literal: true

module Domain
  # Parses a news from an HTML document
  class NewsUniverso
    def fill_from(document, url)
      @title = document.xpath("//h1[@class = 'title-node']").text
      @datetime = document.xpath("//div[@class = 'view-content']/div/div/span")[-2].text
      @content = document.xpath("//div[@class = 'field-content']/div/*[not(self::div)]")
                         .map(&:text).map(&:strip).reject(&:empty?).join "\n"
      @url = url
      @provider = 'El Universo'
      self
    end

    def to_json(_ = nil)
      { title: @title, datetime: @datetime, content: @content, url: @url, provider: @provider }.to_json
    end
  end
end
