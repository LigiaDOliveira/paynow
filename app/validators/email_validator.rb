require 'mail'
class EmailValidator < ActiveModel::EachValidator
  INVALID_DOMAINS = File.open('./app/validators/invalid_domain_names.txt').read.split("\n").freeze

  def validate_each(record, attribute, value)
    @value = value
    @email = Mail::Address.new(value)
    record.errors.add(attribute, message: 'inválido') unless valid?
    valid?
  end

  private

  def conditions
    [
      @email.domain.present?,
      @email.domain.match('\.'),
      @email.address == @value,
      valid_domain?
    ]
  end

  def valid?
    conditions.all?
  rescue StandardError
    false
  end

  def valid_domain?
    INVALID_DOMAINS.exclude? @email.domain
  end
end
