class Gathering < ActiveRecord::Base
  attr_reader :agreement

  validates_acceptance_of :agreement, :allow_nil => false, :accept => true

end
