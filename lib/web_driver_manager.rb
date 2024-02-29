# frozen_string_literal: true

class WebDriverManager
  def self.build
    new.setup_driver
  end

  def setup_driver
    options = Selenium::WebDriver::Chrome::Options.new
    options.add_argument('--headless')
    options.add_argument('--disable-gpu')
    options.add_argument("--user-agent=#{generate_user_agent(device_type: 'desktop')}")

    Selenium::WebDriver.for :chrome, options:
  end
end
