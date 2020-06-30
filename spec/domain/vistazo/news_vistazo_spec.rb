# frozen_string_literal: true

RSpec.describe Domain::NewsVistazo do
  context 'valid digital news' do
    let(:vistazo) { described_class.new }
    let(:page) { Nokogiri::HTML.parse File.read('spec/domain/examples/vistazo.html') }
    let(:url) { 'url__' }

    it 'saves news name' do
      title = execute_news_filling['title']
      expect(title).to eq 'Noticia solo de ejemplo'
    end

    it 'saves news datetime' do
      date = execute_news_filling['datetime']
      expect(date).to eq ' Viernes, 01 de Mayo de 2020 - 13:08'
    end

    it 'saves news content' do
      expected_content = "Párrafo 1.\nPárrafo Fuerte.\nPárrafo 3.\nPárrafo. 4.\nDentro de DIV."
      content = execute_news_filling['content']
      expect(content).to eq expected_content
    end

    it 'saves news url' do
      date = execute_news_filling['url']
      expect(date).to eq url
    end

    def execute_news_filling
      JSON.parse(vistazo.fill_from(page, url).to_json)
    end 
  end
end
