require 'mail'
class EmailValidator < ActiveModel::EachValidator
  def validate_each(record,attribute,value)
    begin
      @m = Mail::Address.new(value)
      # We must check that value contains a domain, the domain has at least
      # one '.' and that value is an email address      
      r = @m.domain.present? && @m.domain.match('\.') && @m.address == value
    rescue   
      r = false
    end
    #record.errors.add(attribute, message: "is invalid") unless r
    if r 
      record.errors.add(attribute, message: "inválido") if invalid_account
    end
  end

  def invalid_account
    invalid_domains.include? @m.domain
  end

  def invalid_domains
    File.open('./app/validators/invalid_domain_names.txt').read.split("\n")
  end
end
