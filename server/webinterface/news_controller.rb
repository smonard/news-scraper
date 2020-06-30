# frozen_string_literal: true

require 'sinatra'
require 'sinatra/json'

module Controller
  # Main Controller
  class NewsController < Sinatra::Application

    get '/news/single' do
      begin
        json NewsExtractorFactory.create_single_news params[:url]
      rescue => e
        error 500, json(error: e.message)
      end
    end
    
    get '/news/:provider' do
      begin
        collector = NewsExtractorFactory.create_news_collector params[:provider]
        json collector.extract
      rescue => e
        error 500, json(error: e.message)
      end
    end

  end
end
