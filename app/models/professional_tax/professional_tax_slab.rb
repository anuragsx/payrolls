class ProfessionalTaxSlab < ActiveRecord::Base

  validates :zone, :salary_min, :salary_max, :tax_amount, :applicable_date, :presence => true
  validates :salary_min, :salary_max, :tax_amount, :numericality => { :only_integer => true }
  validates :applicable_month, :inclusion => { :in => 1..12, :allow_blank => true }

  scope :for_zone, lambda{|z|{:conditions => ["zone = ?",z]}}
  scope :for_gross, lambda{|a|{:conditions => ["? between salary_min and salary_max",a]}}
  scope :for_date, lambda{|d|{:conditions => ["? > applicable_date and ? = ifnull(applicable_month,?)",
                                                    d,d.month,d.month],
                                    :limit => 1,
                                    :order => 'applicable_date desc, applicable_month desc'}}

  def self.zones
    all(:select => 'distinct(zone) as zone').map(&:zone)
  end

  def self.create_slabs_for(zone,slabs)
    first_date = Date.new(2000,1,1)
    salary_max = 1000000.00
    transaction do
      slabs.each do |s|
        create!(:zone => zone,
                :salary_min => s[0], :salary_max => (s[2] || salary_max),
                :tax_amount => s[1],
                :applicable_date => (s[3] || first_date),
                :applicable_month => s[4])
      end
    end
  end
end
