# frozen_string_literal: true

module Domain
  # Parses a news from an HTML document (El Telegrafo)
  class NewsTelegrafo
    def fill_from(document, url)
      @title = document.xpath("//article/div/h1[@class = 'story-heading']").text
      @datetime = document.xpath("//article/div/span[@class = 'story-publishup']").text
      @content = document.xpath("//div/div/div/div[@itemprop = 'articleBody']/p")
                         .map(&:text).map(&:strip).reject(&:empty?).join "\n"
      @url = url
      @provider = 'El Telegrafo'
      self
    end

    def to_json(_ = nil)
      { title: @title, datetime: @datetime, content: @content, url: @url, provider: @provider }.to_json
    end
  end
end
