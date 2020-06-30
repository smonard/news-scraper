# frozen_string_literal: true

RSpec.describe Domain::VistazoCollector do
  context 'no network errors' do
    let(:client) { double('WebClient') }
    let(:collector) { described_class.new client }

    before do
      index_page = Nokogiri::HTML.parse File.read('spec/domain/examples/index_vistazo.html')
      allow(client).to receive(:get_page).with(/page/).and_return index_page
    end

    it 'extracts every single news indexed in main page' do
      news_vistazo = double('NewsVistazo')
      allow(client).to receive(:get_page).with(/vnews/).and_return 'my_page'
      allow(news_vistazo).to receive(:fill_from).with('my_page', /vnews/).and_return('news')
      allow(Domain::NewsVistazo).to receive(:new).and_return news_vistazo

      result = collector.extract

      expect(result).to match_array(%w[news news])
    end

    it 'filters filing news, represented as null' do
      news_vistazo = double('NewsVistazo')
      allow(news_vistazo).to receive(:fill_from).with('my_page', /vnews/).and_return('news')
      allow(Domain::NewsVistazo).to receive(:new).and_return news_vistazo
      stub_error = true
      allow(client).to receive(:get_page).with(/vnews/) do |_|
        stub_error = !stub_error
        raise Net::OpenTimeout unless stub_error
        'my_page'
      end
      result = collector.extract

      expect(result).to match_array(%w[news])
    end
  end
end
