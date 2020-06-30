# frozen_string_literal: true

RSpec.describe Domain::UniversoCollector do
  context 'no network errors' do
    let(:client) { double('WebClient') }
    let(:collector) { described_class.new client }

    before do
      index_page = Nokogiri::HTML.parse File.read('spec/domain/examples/index_eluniverso.html')
      allow(client).to receive(:get_page).with(/page/).and_return index_page
    end

    it 'extracts every single news indexed in main page' do
      news_universo = double('NewsUniverso')
      allow(news_universo).to receive(:fill_from).with('my_page', /nota/).and_return('news')
      allow(Domain::NewsUniverso).to receive(:new).and_return news_universo
      allow(client).to receive(:get_page).with(/nota/).and_return 'my_page'

      result = collector.extract

      expect(result).to match_array(%w[news news news news news news news news])
    end

    it 'filters filing news, represented as null' do
      news_universo = double('NewsUniverso')
      allow(news_universo).to receive(:fill_from).with('my_page', /nota/).and_return('news')
      allow(Domain::NewsUniverso).to receive(:new).and_return news_universo
      stub_error = true
      allow(client).to receive(:get_page).with(/nota/) do |_|
        stub_error = !stub_error
        raise Net::OpenTimeout unless stub_error
        'my_page'
      end
      result = collector.extract

      expect(result).to match_array(%w[news news news news])
    end
  end
end
