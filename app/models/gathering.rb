class Gathering < ActiveRecord::Base
  attr_reader :agreement

  validates_acceptance_of :agreement

end
