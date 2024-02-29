# frozen_string_literal: true

class ScrapeService
  CACHE_TTL = 1.hour

  attr_reader :scraped_data, :errors

  # @param url [String]
  # @param fields [Hash]
  def initialize(url, fields)
    @url = url
    @fields = fields
    @errors = []
    @scraped_data = {}
  end

  def call
    begin
      body = Nokogiri::HTML.parse(page_source)
      @scraped_data = extract_data(body)
    rescue StandardError => e
      @errors << e.message
    ensure
      driver.quit
    end

    self
  end

  def success?
    @errors.empty?
  end

  def failure?
    !success?
  end

  private

  def driver
    @driver ||= WebDriverManager.build
  end

  def page_source
    cached_page_source || fetch_page_source_and_cache
  end

  def cached_page_source
    Rails.cache.read(cache_key)
  end

  def fetch_page_source_and_cache
    Rails.cache.fetch(cache_key, expires_in: CACHE_TTL, race_condition_ttl: 5) do
      driver.get(@url)
      driver.page_source
    end
  end

  def cache_key
    "scrape_service:#{@url}"
  end

  def extract_data(body)
    @fields.each_with_object({}) do |(field_name, selector), scraped_data|
      scraped_data[field_name] = extract_data_for_field(field_name, selector, body)
    end
  end

  def extract_data_for_field(field_name, selector, body)
    case field_name
    when 'meta'
      selector.each_with_object({}) do |meta_name, meta_data|
        meta_tag = body.css("meta[name='#{meta_name}']").first
        meta_data[meta_name] = meta_tag['content'] if meta_tag
      end
    else
      body.css(selector).text.strip
    end
  end
end
