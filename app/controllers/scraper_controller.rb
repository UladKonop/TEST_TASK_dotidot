# frozen_string_literal: true

class ScraperController < ApplicationController
  before_action :validate_params, only: [:scrape]

  def scrape
    url = params[:url]
    fields = params[:fields]

    scraped_data = {}

    options = Selenium::WebDriver::Chrome::Options.new
    options.add_argument('--headless')
    options.add_argument('--disable-gpu')
    options.add_argument("--user-agent=#{generate_user_agent(device_type: 'desktop')}")
    
    driver = Selenium::WebDriver.for :chrome, options: options

    driver.get(url)

    body = Nokogiri::HTML.parse(driver.page_source)

    fields.each do |field_name, selector|
      scraped_data[field_name] = body.css(selector).text.strip
    end

    render json: scraped_data
  end

  private

  def validate_params
    permitted_params = params.permit(:url, fields: {})

    unless permitted_params[:url].present? && permitted_params[:fields].present?
      render json: { error: "'url' and 'fields' are required" }, status: :unprocessable_entity
      return
    end
  end
end
