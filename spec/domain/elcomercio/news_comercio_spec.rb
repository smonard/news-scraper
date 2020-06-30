# frozen_string_literal: true

RSpec.describe Domain::NewsComercio do
  context 'valid digital news' do
    let(:comercio) { described_class.new }
    let(:page) { Nokogiri::HTML.parse File.read('spec/domain/examples/elcomercio.html') }
    let(:url) { 'url_' }

    it 'saves news name' do
      title = execute_news_filling['title']
      expect(title).to eq 'titular de noticia'
    end

    it 'saves news datetime' do
      date = execute_news_filling['datetime']
      expect(date).to eq '2 de mayo de 2020 00:00'
    end

    it 'saves news content' do
      expected_content = "Inicio ro.\nLaSed deAunque,EnlaceDice.Después\nLestareas lanormalidadalcalde.Elrebrote"
      content = execute_news_filling['content']
      expect(content).to eq expected_content
    end

    it 'saves news url' do
      actual_url = execute_news_filling['url']
      expect(actual_url).to eq url
    end

    def execute_news_filling
      JSON.parse(comercio.fill_from(page, url).to_json)
    end 
  end
end
