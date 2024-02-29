class ScraperParamsForm
  include ActiveModel::Model

  attr_accessor :url, :fields

  validates :url, presence: true, format: { with: URI::DEFAULT_PARSER.make_regexp }
  validates :fields, presence: true
  validate :fields_is_a_hash

  private

  def fields_is_a_hash
    errors.add(:fields, 'must be a hash') unless fields.is_a?(Hash)
  end
end
