# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ScraperController, type: :controller do
  describe 'GET #scrape' do
    let(:url) { 'https://example.com' }
    let(:fields) { { 'title' => 'h1' } }
    let(:html) { '<html><body><h1>Title</h1><p>Content</p></body></html>' }
    let(:invalid_params) { { url: '', fields: {} } }

    context 'with valid parameters' do
      before do
        allow_any_instance_of(Selenium::WebDriver::Driver).to receive(:page_source).and_return(html)
        allow(Nokogiri::HTML).to receive(:parse).with(html).and_return(Nokogiri::HTML(html))
        allow_any_instance_of(Nokogiri::HTML::Document).to receive(:css).with('h1').and_return(Nokogiri::HTML(html).css('h1'))
      end

      it 'returns scraped data' do
        get :scrape, params: { url:, fields: }
        expect(response).to have_http_status(:success)
        expect(JSON.parse(response.body)).to eq({ 'title' => 'Title' })
      end
    end

    context 'with invalid parameters' do
      it 'returns unprocessable entity error' do
        get :scrape, params: invalid_params
        expect(response).to have_http_status(:unprocessable_entity)
        expect(JSON.parse(response.body)).to eq({ 'error' => "'url' and 'fields' are required" })
      end
    end
  end
end
