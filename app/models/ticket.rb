class Ticket < ActiveRecord::Base
  attr_reader :terms_of_service

  validates_acceptance_of :terms_of_service, :allow_nil => false, :accept => true
end
