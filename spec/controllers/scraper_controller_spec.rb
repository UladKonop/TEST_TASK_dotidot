# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ScraperController, type: :controller do
  describe 'GET #new' do
    context 'with valid parameters' do
      let(:valid_params) { { 'url' => 'http://example.com', 'fields' => { 'title' => 'h1' } } }

      before do
        service_double = instance_double(ScrapeService)
        allow(ScrapeService).to receive(:new).with(valid_params['url'], valid_params['fields']).and_return(service_double)
        allow(service_double).to receive(:call).and_return(service_double)
        allow(service_double).to receive(:success?).and_return(true)
        allow(service_double).to receive(:scraped_data).and_return("{\"title\":\"Title\"}")
      end

      it 'makes request with the correct parameters and checks success' do
        get :new, params: valid_params
        expect(ScrapeService).to have_received(:new).with(valid_params['url'], valid_params['fields'])
        expect(response).to have_http_status(:ok)
        expect(response.body).to eq("{\"title\":\"Title\"}")
      end
    end

    context 'with invalid parameters' do
      let(:invalid_params) { { 'url' => '', 'fields' => { } } }

      it 'makes request with invalid parameters and checks failure' do
        get :new, params: invalid_params
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end
end
