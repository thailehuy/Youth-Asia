class Ticket < ActiveRecord::Base
  attr_reader :agreement

  validates_acceptance_of :agreement, :allow_nil => false
end
