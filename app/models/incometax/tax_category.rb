class TaxCategory < ActiveRecord::Base

  has_many :tax_slabs

  validates :category, :presence => true
  
end