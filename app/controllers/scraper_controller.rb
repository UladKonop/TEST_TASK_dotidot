# frozen_string_literal: true

class ScraperController < ApplicationController
  def new
    scraper_params = ScraperParamsForm.new(permitted_params)
    unless scraper_params.valid?
      render json: { error: scraper_params.errors.full_messages.join(', ') },
             status: :unprocessable_entity
      return
    end

    service = ScrapeService.new(scraper_params.url, scraper_params.fields)
    result = service.call

    if result.success?
      render json: service.scraped_data, status: :ok
    else
      render json: { error: service.errors }, status: :unprocessable_entity
    end
  end

  private

  def permitted_params
    params.permit(:url, fields: {})
  end
end
