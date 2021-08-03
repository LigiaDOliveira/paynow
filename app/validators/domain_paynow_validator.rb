require 'mail'
class DomainPaynowValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    begin
      @m = Mail::Address.new(value)
      domain_paynow = @m.domain.present? &&
                      @m.domain.match('\.') &&
                      @m.address == value &&
                      @m.domain == 'paynow.com.br'
    rescue StandardError
      domain_paynow = false
    end

    record.errors.add(attribute, message: ': Permissão de administrador negada') unless domain_paynow
  end
end
