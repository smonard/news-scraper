# frozen_string_literal: true

module Domain
  # Parses a news from an HTML document (El Expreso)
  class NewsExpreso
    def fill_from(document, url)
      @title = document.xpath('//div/h1').text
      @datetime = document.xpath("//time").text
      @content = document.xpath("//div[@class = 'box3x1 flo-left con']/div/div/p[@class = 'paragraph ']")
                         .map(&:text).map(&:strip).reject(&:empty?).join "\n"
      @url = url
      @provider = 'El Expreso'
      self
    end

    def to_json(_ = nil)
      { title: @title, datetime: @datetime, content: @content, url: @url, provider: @provider }.to_json
    end
  end
end
