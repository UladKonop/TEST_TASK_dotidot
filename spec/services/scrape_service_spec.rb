# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ScrapeService, type: :controller do
  let(:url) { 'https://example.com' }
  let(:fields) { { 'title' => 'h1' } }
  let(:meta_fields) { { 'meta' => ['keywords'] } }
  let(:html) { '<html><body><h1>Title</h1><p>Content</p></body></html>' }
  let(:meta_html) { '<html><head><meta name="keywords" content="keyword"</head></html>' }

  describe '#call' do
    context 'with valid fields parameters' do
      before do
        allow(Nokogiri::HTML).to receive(:parse).with(html).and_return(Nokogiri::HTML(html))
        allow_any_instance_of(Selenium::WebDriver::Driver).to receive(:page_source).and_return(html)
      end

      it 'returns true' do
        result = ScrapeService.new(url, fields).call

        expect(result.success?).to be true
      end
    end

    context 'with valid meta fields parameters' do
      before do
        allow(Nokogiri::HTML).to receive(:parse).with(meta_html).and_return(Nokogiri::HTML(meta_html))
        allow_any_instance_of(Selenium::WebDriver::Driver).to receive(:page_source).and_return(meta_html)
      end

      it 'returns true' do
        result = ScrapeService.new(url, meta_fields).call

        expect(result.success?).to be true
      end
    end

    context 'with invalid parameters' do
      before do
        allow(Nokogiri::HTML).to receive(:parse).with(meta_html).and_return(Nokogiri::HTML(meta_html))
        allow_any_instance_of(Selenium::WebDriver::Driver).to receive(:page_source).and_return(meta_html)
      end

      it 'raises an error with invalid arguments' do
        result = ScrapeService.new('', {}).call

        expect(result.success?).to be false
      end
    end
  end
end
