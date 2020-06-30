# frozen_string_literal: true

RSpec.describe Domain::ComercioCollector do
  context 'no network errors' do
    let(:client) { double('WebClient') }
    let(:collector) { described_class.new client }

    before do
      index_page = Nokogiri::HTML.parse File.read('spec/domain/examples/index_elcomercio.html')
      allow(client).to receive(:get_page).with(/Ecuador/).and_return index_page
    end

    it 'extracts every single news indexed in main page' do
      news_comercio = double('NewsComercio')
      allow(client).to receive(:get_page).with(/html/).and_return 'my_page'
      allow(news_comercio).to receive(:fill_from).with('my_page', /html/).and_return('news')
      allow(Domain::NewsComercio).to receive(:new).and_return news_comercio

      result = collector.extract

      expect(result).to match_array(%w[news news news news])
    end

    it 'filters filing news, represented as null' do
      news_comercio = double('NewsComercio')
      allow(news_comercio).to receive(:fill_from).with('my_page', /html/).and_return('news')
      allow(Domain::NewsComercio).to receive(:new).and_return news_comercio
      stub_error = true
      allow(client).to receive(:get_page).with(/html/) do |_|
        stub_error = !stub_error
        raise Net::OpenTimeout unless stub_error
        'my_page'
      end
      result = collector.extract

      expect(result).to match_array(%w[news news])
    end
  end
end
