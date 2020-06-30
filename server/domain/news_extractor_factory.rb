# frozen_string_literal: true
require 'domain/elcomercio/comercio_collector'
require 'domain/eluniverso/universo_collector'
require 'domain/elcomercio/news_comercio'
require 'domain/eluniverso/news_universo'

class NewsExtractorFactory
  @@providers = {
    vistazo: { collector: Domain::VistazoCollector, klass: Domain::NewsVistazo, server: 'https://www.vistazo.com' },
    comercio: { collector: Domain::ComercioCollector, klass: Domain::NewsComercio, server: 'https://www.elcomercio.com' },
    universo: { collector: Domain::UniversoCollector, klass: Domain::NewsUniverso, server: 'https://www.eluniverso.com' }
  }

  def self.create_single_news(url)
    server_data = url.match(/^https:\/\/www\.[a-z]*\.com/)
    raise StandardError, 'Invalid URL' if server_data.nil?
    
    provider_details = @@providers.select {|_, v|  v[:server].eql? server_data[0] }.values
    raise StandardError, 'Unsupported provider' if provider_details.empty?
    
    doc = Port::WebClient.new.get_page url
    return provider_details[0][:klass].new.fill_from doc, url
  end

  def self.create_news_collector(provider)
    provider_details = @@providers[provider]
    raise StandardError, 'Unsupported provider' if provider_details.nil?
    
    return provider_details[:collector].new
  end

end