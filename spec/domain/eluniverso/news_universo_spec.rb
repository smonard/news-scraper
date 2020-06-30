# frozen_string_literal: true

RSpec.describe Domain::NewsUniverso do
  context 'valid digital news' do
    let(:universo) { described_class.new }
    let(:page) { Nokogiri::HTML.parse File.read('spec/domain/examples/eluniverso.html') }
    let(:url) { 'url__' }

    it 'saves news name' do
      title = execute_news_filling['title']
      expect(title).to eq 'Nombre inicial'
    end

    it 'saves news datetime' do
      date = execute_news_filling['datetime']
      expect(date).to eq '22 de Abril, 2020 - 18h45'
    end

    it 'saves news content' do
      expected_content = "Colegios públicos y privados.\nGerente.\nImportante\nEducación).\nImportante 2\nDestina al transporte.\nSitio web www.link.ec (I)"
      content = execute_news_filling['content']
      expect(content).to eq expected_content
    end

    it 'saves news url' do
      actual_url = execute_news_filling['url']
      expect(actual_url).to eq url
    end

    def execute_news_filling
      JSON.parse(universo.fill_from(page, url).to_json)
    end 
  end
end
