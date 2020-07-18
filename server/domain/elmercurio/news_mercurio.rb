# frozen_string_literal: true

module Domain
  # Parses a news from an HTML document (El Mercurio)
  class NewsMercurio
    def fill_from(document, url)
      @title = document.xpath("//h1[@class = 'entry-title']").text
      @datetime = document.xpath("//time").text
      @content = document.xpath("//article/div[@class = 'td-post-content']/p")
                         .map(&:text).map(&:strip).reject(&:empty?).join "\n"
      @url = url
      @provider = 'El Mercurio'
      self
    end

    def to_json(_ = nil)
      { title: @title, datetime: @datetime, content: @content, url: @url, provider: @provider }.to_json
    end
  end
end
